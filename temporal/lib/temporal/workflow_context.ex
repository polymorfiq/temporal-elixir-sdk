defmodule Temporal.WorkflowContext do
  use GenServer

  require Record
  require TemporalEngine.Data.Jobs

  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Timestamp

  @type t :: workflow_context()

  Record.defrecord(:workflow_context, [
    :task_queue,
    :workflow_id,
    :namespace,
    :run_id,
    :initialize_config,
    :context,
    :execution,
    :runtime,
    activity_options: [],
    child_workflow_options: []
  ])

  @type workflow_context ::
          record(:workflow_context,
            task_queue: String.t(),
            workflow_id: String.t(),
            namespace: String.t(),
            run_id: String.t(),
            context: pid(),
            execution: pid(),
            runtime: pid(),
            initialize_config: Jobs.initialize_workflow(),
            activity_options: Commands.schedule_activity_opts(),
            child_workflow_options: Commands.start_child_workflow_execution_opts()
          )

  Record.defrecordp(:context_state, [
    :task,
    running_handlers: 0
  ])

  @typep context_state ::
           record(:context_state,
             task: task_state(),
             running_handlers: non_neg_integer()
           )

  Record.defrecordp(:task_state, [
    :timestamp,
    :is_replaying,
    :history_size,
    :history_length,
    :continue_as_new_suggested,
    :continue_as_new_suggested_reasons,
    :target_worker_deployment_version_changed,
    :current_task_build_id,
    :current_task_run_id
  ])

  @typep task_state ::
           record(:task_state,
             timestamp: DateTime.t(),
             is_replaying: boolean(),
             history_size: non_neg_integer(),
             history_length: non_neg_integer(),
             continue_as_new_suggested: boolean(),
             continue_as_new_suggested_reasons: [atom()],
             target_worker_deployment_version_changed: boolean(),
             current_task_build_id: String.t(),
             current_task_run_id: String.t()
           )

  def init(activation) do
    {:ok, context_state(task: activation_to_state(activation))}
  end

  def update_for_activation(workflow_context(context: pid), activate) do
    GenServer.cast(pid, {:update_for_activation, activate})
  end

  def get_task_metadata(workflow_context(context: pid)) do
    GenServer.call(pid, :get_task_metadata, :infinity)
  end

  def all_handlers_finished?(workflow_context(context: pid)) do
    GenServer.call(pid, :all_handlers_finished?, :infinity)
  end

  def handler_started(workflow_context(context: pid)) do
    GenServer.cast(pid, :handler_started)
  end

  def handler_finished(workflow_context(context: pid)) do
    GenServer.cast(pid, :handler_finished)
  end

  @spec handle_cast(term(), context_state()) :: {:noreply, context_state()}
  def handle_cast(:handler_started, state) do
    handlers = context_state(state, :running_handlers) + 1
    {:noreply, context_state(state, running_handlers: handlers)}
  end

  def handle_cast(:handler_finished, state) do
    handlers = context_state(state, :running_handlers) - 1
    {:noreply, context_state(state, running_handlers: handlers)}
  end

  def handle_cast({:update_for_activation, activate}, state) do
    {:noreply, context_state(state, task: activation_to_state(activate))}
  end

  @spec handle_call(term(), {pid(), term()}, context_state()) ::
          {:noreply, context_state()} | {:reply, term(), context_state()}
  def handle_call(:all_handlers_finished?, _from, state) do
    {:reply, context_state(state, :running_handlers) == 0, state}
  end

  def handle_call(:get_task_metadata, _from, state) do
    task = context_state(state, :task)

    {:reply,
     %{
       timestamp: task_state(task, :timestamp),
       is_replaying: task_state(task, :is_replaying),
       history_size: task_state(task, :history_size),
       history_length: task_state(task, :history_length),
       continue_as_new_suggested: task_state(task, :continue_as_new_suggested),
       continue_as_new_suggested_reasons: task_state(task, :continue_as_new_suggested_reasons),
       target_worker_deployment_version_changed:
         task_state(task, :target_worker_deployment_version_changed),
       current_task_build_id: task_state(task, :current_task_build_id),
       current_task_run_id: task_state(task, :current_task_run_id)
     }, state}
  end

  defp activation_to_state(activate) do
    import TemporalEngine.Data.Activation
    import TemporalEngine.Data.Common

    build_id =
      if version = activation(activate, :deployment_version_for_current_task) do
        worker_deployment_version(version, :build_id)
      end

    task_state(
      timestamp: Timestamp.to_native(activation(activate, :timestamp)),
      is_replaying: activation(activate, :is_replaying),
      history_size: activation(activate, :history_size_bytes),
      history_length: activation(activate, :history_length),
      continue_as_new_suggested: activation(activate, :continue_as_new_suggested),
      continue_as_new_suggested_reasons: activation(activate, :suggest_continue_as_new_reasons),
      target_worker_deployment_version_changed:
        activation(activate, :target_worker_deployment_version_changed),
      current_task_build_id: build_id,
      current_task_run_id: activation(activate, :run_id)
    )
  end
end
