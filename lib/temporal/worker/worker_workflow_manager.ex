defmodule Temporal.Worker.WorkerWorkflowManager do
  use GenServer
  alias Temporal.Worker
  alias Temporal.WorkflowRegistry
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Supervisor.WorkerSupervisor

  require Logger
  require Record
  Record.defrecordp(:manager_state, [:id, registered: %{}, forward_polled_pid: nil])

  def start_link({worker_id, opts, server_opts}) do
    GenServer.start_link(__MODULE__, {worker_id, opts}, server_opts)
  end

  @spec init({String.t(), Worker.worker_opts()}) :: {:ok, pid()} | {:error, term()}
  def init({worker_id, opts}) do
    {:ok, manager_state(id: worker_id, forward_polled_pid: opts[:forward_polled_messages])}
  end

  def process_activation_job(pid, job), do: GenServer.call(pid, {:job, job}, :infinity)
  def flush(pid), do: GenServer.call(pid, :flush, :infinity)
  def register(pid, name, module), do: GenServer.cast(pid, {:register, name, module})

  def stop_workflow_with_id(pid, workflow_id),
    do: GenServer.cast(pid, {:stop_workflow_id, workflow_id})

  def handle_cast({:register, name, module}, state) do
    registered = manager_state(state, :registered)
    {:noreply, manager_state(state, registered: Map.put(registered, name, module))}
  end

  def handle_cast({:stop_workflow_id, workflow_id}, state) do
    if sup = GenServer.whereis(workflow_sup_id(workflow_id)) do
      spawn(fn ->
        Supervisor.stop(sup, :shutdown, :infinity)
      end)
    end

    {:noreply, state}
  end

  def handle_call(:flush, _from, state), do: {:reply, :ok, state}

  def handle_call({:job, job}, _from, state) do
    if forward_to = manager_state(state, :forward_polled_pid) do
      send(forward_to, {:workflow_activation_job, job})
    end

    {resp, state} = handle_activation_job(job, state)

    {:reply, resp, state}
  end

  def handle_activation_job({:initialize_workflow, initialize}, state) do
    worker_id = manager_state(state, :id)
    registered = manager_state(state, :registered)

    resp =
      if workflow_module = registered[initialize.workflow_type] do
        reg_name = workflow_sup_id(initialize.workflow_id)

        with {:ok, workflows_sup} <- WorkerSupervisor.workflows_sup_for_id(worker_id) do
          child_started =
            DynamicSupervisor.start_child(
              workflows_sup,
              Supervisor.child_spec(
                {WorkflowSupervisor,
                 {
                   initialize.workflow_id,
                   workflow_module,
                   manager_state(state, :id),
                   initialize,
                   [name: reg_name]
                 }},
                restart: :transient
              )
            )

          with {:ok, _} <- child_started do
            :ok
          end
        end
      else
        Logger.warning(
          "Ignoring unregistered workflow type: #{inspect(initialize.workflow_type)}"
        )

        :ok
      end

    {resp, state}
  end

  def handle_activation_job({variant, _job}, state) do
    Logger.error(
      "Worker Workflow Manager received unknown workflow activation: #{inspect(variant)}"
    )

    {:ok, state}
  end

  defp workflow_sup_id(workflow_id),
    do: {:via, Registry, {WorkflowRegistry, {:workflow, workflow_id}}}
end
