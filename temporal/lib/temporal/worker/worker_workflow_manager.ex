defmodule Temporal.Worker.WorkerWorkflowManager do
  use GenServer

  require Logger
  require Record

  import TemporalEngine.Data.Activation
  import TemporalEngine.Data.Jobs

  alias Temporal.CoreSdk.CoreWorker
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.TaskQueue
  alias Temporal.Worker
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Workflow.WorkflowProgressReporter

  Record.defrecordp(:manager_state, [
    :id,
    :task_queue,
    :exec_ctx,
    :core_worker,
    registered: %{}
  ])

  def start_link({exec_ctx, config, server_opts}) do
    GenServer.start_link(__MODULE__, {exec_ctx, config}, server_opts)
  end

  @spec init({String.t(), TaskQueue.t(), Worker.worker_opts()}) :: {:ok, pid()} | {:error, term()}
  def init({exec_ctx, _config}) do
    Process.set_label({:workflow_manager, exec_ctx.worker_id})

    with {:ok, core_worker} <- CoreWorker.existing_for_id(exec_ctx.worker_id) do
      {:ok,
       manager_state(
         exec_ctx: exec_ctx,
         id: exec_ctx.worker_id,
         task_queue: exec_ctx.task_queue,
         core_worker: core_worker
       )}
    end
  end

  def process_activation(pid, activation) do
    GenServer.call(pid, {:process_activation, activation}, :infinity)
  end

  def register(pid, name, module, execute_fn),
    do: GenServer.cast(pid, {:register, name, module, execute_fn})

  def handle_cast({:register, name, module, execute_fn}, state) do
    registered = manager_state(state, :registered)
    {:noreply, manager_state(state, registered: Map.put(registered, name, {module, execute_fn}))}
  end

  def handle_call({:process_activation, {:error, "core_shutdown"}}, _from, state) do
    Logger.warning("Workflow Manager received a 'core_shutdown' and is shutting down...")
    {:noreply, state}
  end

  def handle_call({:process_activation, activation() = activation}, _from, state) do
    jobs = activation(activation, :jobs)

    processed =
      Enum.reduce(jobs, {:ok, state}, fn job, curr ->
        with {:ok, state} <- curr do
          handle_activation_job(job, activation, state)
        end
      end)

    with {:ok, state} <- processed do
      {:reply, :ok, state}
    else
      {{:error, err}, _} ->
        {:reply, {:error, err}, state}
    end
  end

  def handle_activation_job(
        job(
          variant:
            initialize_workflow(
              workflow_id: workflow_id,
              workflow_type: workflow_type,
              arguments: args
            )
        ),
        activation(run_id: run_id),
        state
      ) do
    exec_ctx = manager_state(state, :exec_ctx)
    registered = manager_state(state, :registered)

    resp =
      if registered[workflow_type] do
        {workflow_module, execute_fn} = registered[workflow_type]
        Logger.debug("Job: initialize_workflow (#{inspect(workflow_module)} - #{run_id})")

        exec_ctx = %{
          exec_ctx
          | workflow_id: workflow_id,
            run_id: run_id,
            workflow_module: workflow_module,
            workflow_execute_fn: execute_fn,
            core_worker: manager_state(state, :core_worker)
        }

        start_or_restart_workflow(exec_ctx, args)
      else
        Logger.warning("Ignoring unregistered workflow type: #{inspect(workflow_type)}")

        WorkflowProgressReporter.send_failure_activation_completion(
          run_id,
          manager_state(state, :core_worker).core,
          "Unknown workflow type: #{inspect(workflow_type)}"
        )

        :ok
      end

    {resp, state}
  end

  def handle_activation_job(
        job(variant: remove_from_cache(reason: reason, message: message)),
        activation(run_id: run_id),
        state
      ) do
    Logger.debug("Job: remove_from_cache (#{reason} - #{run_id} - #{message})")

    Logger.info("Removing from cache (#{reason} - #{message}): Workflow Run (#{run_id})")

    WorkflowSupervisor.stop_workflow(run_id)

    WorkflowProgressReporter.send_successful_activation_completion(
      run_id,
      manager_state(state, :core_worker).core,
      []
    )

    {:ok, state}
  end

  def handle_activation_job(_job, activation, state) do
    WorkflowProgressReporter.process_activation(activation)

    {:ok, state}
  end

  @spec start_or_restart_workflow(ExecutionContext.t(), args :: [term]) :: :ok | {:error, term()}
  def start_or_restart_workflow(exec_ctx, args) do
    with {:ok, workflows_sup} <- WorkerSupervisor.workflows_sup_for_id(exec_ctx.worker_id) do
      DynamicSupervisor.start_child(
        workflows_sup,
        Supervisor.child_spec(
          {WorkflowSupervisor,
           {exec_ctx, args, [name: WorkflowSupervisor.process_name(exec_ctx.run_id)]}},
          restart: :temporary
        )
      )
      |> case do
        {:ok, _} ->
          :ok

        {:error, {:already_started, _}} ->
          Logger.warning(
            "Workflow Run (#{exec_ctx.run_id}) initialized after already being started... Restarting..."
          )

          WorkflowSupervisor.stop_workflow(exec_ctx.run_id)
          start_or_restart_workflow(exec_ctx, args)

        {:error, err} ->
          {:error, err}
      end
    end
  end
end
