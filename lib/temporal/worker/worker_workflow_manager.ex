defmodule Temporal.Worker.WorkerWorkflowManager do
  use GenServer
  alias Temporal.TaskQueue
  alias Temporal.Worker
  alias Temporal.WorkflowRegistry
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Workflow.WorkflowProgressReporter

  require Logger
  require Record

  Record.defrecordp(:manager_state, [
    :id,
    :task_queue,
    :exec_ctx,
    registered: %{},
    forward_polled_pid: nil
  ])

  def start_link({exec_ctx, opts, server_opts}) do
    GenServer.start_link(__MODULE__, {exec_ctx, opts}, server_opts)
  end

  @spec init({String.t(), TaskQueue.t(), Worker.worker_opts()}) :: {:ok, pid()} | {:error, term()}
  def init({exec_ctx, opts}) do
    {:ok,
     manager_state(
       exec_ctx: exec_ctx,
       id: exec_ctx.worker_id,
       task_queue: exec_ctx.task_queue,
       forward_polled_pid: opts[:forward_polled_messages]
     )}
  end

  def process_activation(pid, activation),
    do: GenServer.call(pid, {:process_activation, activation}, :infinity)

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

  def handle_call({:process_activation, activation}, _from, state) do
    if forward_to = manager_state(state, :forward_polled_pid) do
      Enum.each(activation.jobs, fn job ->
        send(forward_to, {:workflow_activation_job, job.variant, activation})
      end)
    end

    processed =
      Enum.reduce(activation.jobs, {:ok, state}, fn job, curr ->
        with {:ok, curr_state} <- curr,
             {:ok, new_state} <- handle_activation_job(job.variant, activation, curr_state) do
          {:ok, new_state}
        end
      end)

    with {:ok, state} <- processed do
      {:reply, :ok, state}
    end
  end

  def handle_activation_job({:initialize_workflow, initialize}, activation, state) do
    exec_ctx = manager_state(state, :exec_ctx)
    worker_id = manager_state(state, :id)
    registered = manager_state(state, :registered)

    resp =
      if workflow_module = registered[initialize.workflow_type] do
        reg_name = workflow_sup_id(initialize.workflow_id)

        with {:ok, worker} <- WorkerSupervisor.core_for_id(worker_id),
             {:ok, workflows_sup} <- WorkerSupervisor.workflows_sup_for_id(worker_id) do
          child_started =
            DynamicSupervisor.start_child(
              workflows_sup,
              Supervisor.child_spec(
                {WorkflowSupervisor,
                 {
                   %{
                     exec_ctx
                     | workflow_id: initialize.workflow_id,
                       run_id: activation.run_id,
                       workflow_module: workflow_module,
                       worker: worker
                   },
                   initialize,
                   [name: reg_name]
                 }},
                restart: :temporary
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

  def handle_activation_job({:remove_from_cache, job}, activation, state) do
    Logger.info(
      "Removing from cache (#{job.reason} - #{job.message}): Workflow Run (#{activation.run_id})"
    )

    if sup = GenServer.whereis(workflow_sup_id(activation.run_id)) do
      spawn(fn ->
        Supervisor.stop(sup, :shutdown, :infinity)
      end)
    end

    {:ok, state}
  end

  def handle_activation_job({:resolve_activity, job}, activation, state) do
    with {:ok, reporter} <- WorkflowSupervisor.progress_reporter_pid(activation.run_id) do
      WorkflowProgressReporter.resolve_activity(reporter, job.seq, job.result.status)
    else
      {:error, err} ->
        Logger.error(
          "Resolve Activity failed (ID: #{activation.workflow_id}, Run ID: #{activation.run_id}) - #{inspect(err)}"
        )
    end

    {:ok, state}
  end

  def handle_activation_job({variant, job}, activation, state) do
    Logger.error(
      "Worker Workflow Manager received unknown workflow activation for (Run ID: #{activation.run_id}): #{inspect(variant)} - #{inspect(job)}"
    )

    {:ok, state}
  end

  defp workflow_sup_id(workflow_id),
    do: {:via, Registry, {WorkflowRegistry, {:workflow, workflow_id}}}
end
