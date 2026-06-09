defmodule Temporal.Worker.WorkerWorkflowManager do
  use GenServer
  alias Temporal.Supervisor.ExecutionContext
  alias Temporal.TaskQueue
  alias Temporal.Worker
  alias Temporal.Supervisor.WorkflowSupervisor
  alias Temporal.Supervisor.WorkerSupervisor
  alias Temporal.Workflow.WorkflowFlowController
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
    Process.set_label({:workflow_manager, exec_ctx.worker_id})

    {:ok,
     manager_state(
       exec_ctx: exec_ctx,
       id: exec_ctx.worker_id,
       task_queue: exec_ctx.task_queue,
       forward_polled_pid: opts[:forward_polled_messages]
     )}
  end

  def process_activation(pid, activation) do
    lock_token =
      with {:ok, token} <- WorkflowFlowController.acquire_progress_lock(activation.run_id) do
        token
      else
        {:error, :flow_control_not_running} ->
          nil

        {:error, err} ->
          Logger.warning(
            "Could not receive lock token for #{activation.run_id} - #{inspect(err)}"
          )

          nil
      end

    resp = GenServer.call(pid, {:process_activation, activation}, :infinity)
    if lock_token, do: WorkflowFlowController.release_progress_lock(activation.run_id, lock_token)

    resp
  end

  def register(pid, name, module), do: GenServer.cast(pid, {:register, name, module})

  def handle_cast({:register, name, module}, state) do
    registered = manager_state(state, :registered)
    {:noreply, manager_state(state, registered: Map.put(registered, name, module))}
  end

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
    registered = manager_state(state, :registered)

    resp =
      if workflow_module = registered[initialize.workflow_type] do
        with {:ok, worker} <- WorkerSupervisor.core_for_id(exec_ctx.worker_id) do
          exec_ctx = %{
            exec_ctx
            | workflow_id: initialize.workflow_id,
              run_id: activation.run_id,
              workflow_module: workflow_module,
              workflow_initialize: initialize,
              worker: worker
          }

          start_or_restart_workflow(exec_ctx)
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

    WorkflowSupervisor.stop_workflow(activation.run_id, wait: true)

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

  @spec start_or_restart_workflow(ExecutionContext.t()) :: :ok | {:error, term()}
  def start_or_restart_workflow(exec_ctx) do
    with {:ok, workflows_sup} <- WorkerSupervisor.workflows_sup_for_id(exec_ctx.worker_id) do
      DynamicSupervisor.start_child(
        workflows_sup,
        Supervisor.child_spec(
          {WorkflowSupervisor,
           {exec_ctx, [name: WorkflowSupervisor.process_name(exec_ctx.run_id)]}},
          restart: :temporary
        )
      )
      |> case do
        {:ok, _} ->
          :ok

        {:error, {:already_started, _}} ->
          WorkflowSupervisor.stop_workflow(exec_ctx.run_id, wait: true)
          start_or_restart_workflow(exec_ctx)

        {:error, err} ->
          {:error, err}
      end
    end
  end
end
