defmodule Temporal.Workflow do
  use TemporalEngine.Data.TypeSpec

  require Temporal.Workflow.ActivityActions
  require Temporal.Workflow.ChildWorkflowActions
  require Temporal.Workflow.TimerActions
  require Temporal.WorkflowContext
  require TemporalEngine.Data.Commands
  require TemporalEngine.Data.Common

  alias Temporal.Workflow.ActivityActions
  alias Temporal.Workflow.AwaitActions
  alias Temporal.Workflow.ChildWorkflowActions
  alias Temporal.Workflow.ContinueAsNewActions
  alias Temporal.Workflow.MessagePassingActions
  alias Temporal.Workflow.TimerActions
  alias Temporal.WorkflowContext
  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Timestamp

  defdelegate execute_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_activity!(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_local_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_local_activity!(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_child_workflow(ctx, name, inputs, opts \\ []), to: ChildWorkflowActions
  defdelegate execute_child_workflow!(ctx, name, inputs, opts \\ []), to: ChildWorkflowActions
  defdelegate continue_as_new_error!(ctx, name, inputs, opts \\ []), to: ContinueAsNewActions
  defdelegate get_child_workflow_execution(handle), to: ChildWorkflowActions
  defdelegate new_timer(ctx, duration), to: TimerActions
  defdelegate sleep(ctx, duration), to: TimerActions
  defdelegate await(ctx, await_check), to: AwaitActions
  defdelegate all_handlers_finished?(ctx), to: AwaitActions
  defdelegate set_query_handler(ctx, name, handler), to: MessagePassingActions
  defdelegate set_update_handler(ctx, name, handler, opts \\ []), to: MessagePassingActions
  defdelegate set_signal_handler(ctx, name, handler), to: MessagePassingActions

  deftype :info do
    @doc "Execution handle for the current workflow"
    @type workflow_execution :: required :: nested!(Common.workflow_execution())

    @doc "The original run_id before resetting. Using it instead of current run_id can make workflow decision deterministic after reset. See also first_run_id"
    @type original_run_id :: required :: String.t()

    @doc "The very first original RunId of the current Workflow Execution preserved along the chain of ContinueAsNew, Retry, Cron and Reset. Identifies the whole Runs chain of Workflow Execution."
    @type first_run_id :: required :: String.t()

    @doc "The type of the current workflow."
    @type workflow_type :: required :: String.t()

    @doc "The name of the current workflow's task queue"
    @type task_queue_name :: required :: String.t()

    @doc "Timeout for the current workflow's execution."
    @type workflow_execution_timeout :: Duration.shorthand()

    @doc "Timeout for the current workflow's tasks."
    @type workflow_task_timeout :: Duration.shorthand()

    @doc "Namespace the current workflow is executing in"
    @type namespace :: required :: String.t()

    @doc "Starts from 1 and increased by 1 for every retry if retry policy is specified."
    @type attempt :: required :: pos_integer()

    @doc "Time the workflow was started. Workflow.utc_now() at the beginning of a workflow can return a later time if the Workflow Worker was down"
    @type workflow_start_time :: required :: DateTime.t()

    @type last_completion_result :: [term()]

    @type last_failure :: map()

    @doc "Cron schedule configured for the current workflow. Blank if not set."
    @type cron_schedule :: required :: String.t()

    @doc "Run ID of the execution from which this one continued"
    @type continued_execution_run_id :: String.t()

    @doc "Namespace of the parent workflow"
    @type parent_workflow_namespace :: String.t()

    @doc "Handle of the parent workflow execution"
    @type parent_workflow_execution :: nested!(Common.workflow_execution())

    @doc "The first workflow execution in the chain of workflows. If a workflow is itself a root workflow, then this field is nil."
    @type root_workflow_execution :: nested!(Common.workflow_execution())

    @doc "Retry policy for the workflow"
    @type retry_policy :: map()

    @doc "Priority settings that control relative ordering of task processing when workflow tasks are backed up in a queue."
    @type priority :: map()

    @doc """
    current_task_build_id, if nonempty, contains the Build ID of the worker that processed the task
    which is currently or about to be executing. If no longer replaying will be set to the ID of this worker
    """
    @type current_task_build_id :: String.t()

    @type continue_as_new_suggested :: required :: boolean()
    @type continue_as_new_suggested_reasons :: required :: [atom()]
    @type target_worker_deployment_version_changed :: boolean()

    @type current_history_size :: required :: non_neg_integer()
    @type current_history_length :: required :: non_neg_integer()

    @doc "The current run ID of the workflow task, deterministic over reset"
    @type current_run_id :: String.t()
  end

  @spec with_activity_opts(
          WorkflowContext.t(),
          activity_opts :: Commands.schedule_activity_opts()
        ) :: WorkflowContext.t()
  def with_activity_opts(ctx, opts) do
    existing_opts = WorkflowContext.workflow_context(ctx, :activity_options)
    WorkflowContext.workflow_context(ctx, activity_options: existing_opts ++ opts)
  end

  @spec with_child_workflow_opts(
          WorkflowContext.t(),
          activity_opts :: Commands.start_child_workflow_execution_opts()
        ) :: WorkflowContext.t()
  def with_child_workflow_opts(ctx, opts) do
    existing_opts = WorkflowContext.workflow_context(ctx, :child_workflow_options)
    WorkflowContext.workflow_context(ctx, child_workflow_options: existing_opts ++ opts)
  end

  @spec utc_now(WorkflowContext.t()) :: DateTime.t()
  def utc_now(ctx), do: WorkflowContext.get_task_metadata(ctx).timestamp

  @spec get_info(WorkflowContext.t()) :: info()
  def get_info(ctx) do
    import Temporal.WorkflowContext
    import TemporalEngine.Data.Jobs
    import TemporalEngine.Data.Priority

    init = WorkflowContext.workflow_context(ctx, :initialize_config)
    parent_info = initialize_workflow(init, :parent_workflow_info)

    parent_exec =
      if parent_info do
        Common.workflow_execution(
          run_id: Common.namespaced_workflow_execution(parent_info, :run_id),
          workflow_id: Common.namespaced_workflow_execution(parent_info, :workflow_id)
        )
      end

    metadata = WorkflowContext.get_task_metadata(ctx)

    info(
      workflow_execution:
        Common.workflow_execution(
          run_id: workflow_context(ctx, :run_id),
          workflow_id: workflow_context(ctx, :workflow_id)
        ),
      original_run_id: initialize_workflow(init, :first_execution_run_id),
      first_run_id: initialize_workflow(init, :first_execution_run_id),
      workflow_type: initialize_workflow(init, :workflow_type),
      task_queue_name: workflow_context(ctx, :task_queue),
      workflow_execution_timeout:
        if(d = initialize_workflow(init, :workflow_execution_timeout), do: Duration.to_tuple(d)),
      workflow_task_timeout:
        if(d = initialize_workflow(init, :workflow_task_timeout), do: Duration.to_tuple(d)),
      namespace: workflow_context(ctx, :namespace),
      attempt: initialize_workflow(init, :attempt),
      workflow_start_time: initialize_workflow(init, :start_time) |> Timestamp.to_native(),
      last_completion_result:
        if(results = initialize_workflow(init, :last_completion_result),
          do: Enum.map(results, &Payload.value_from_record/1)
        ),
      last_failure: if(f = initialize_workflow(init, :continued_failure), do: Failure.to_map(f)),
      cron_schedule: initialize_workflow(init, :cron_schedule),
      continued_execution_run_id: initialize_workflow(init, :continued_from_execution_run_id),
      parent_workflow_execution: parent_exec,
      root_workflow_execution: initialize_workflow(init, :root_workflow),
      retry_policy:
        if(policy = initialize_workflow(init, :retry_policy),
          do: %{
            initial_interval:
              if(d = Common.retry_policy(policy, :initial_interval), do: Duration.to_tuple(d)),
            backoff_coefficient: Common.retry_policy(policy, :backoff_coefficient),
            maximum_interval:
              if(d = Common.retry_policy(policy, :maximum_interval), do: Duration.to_tuple(d)),
            maximum_attempts: Common.retry_policy(policy, :maximum_attempts),
            non_retryable_error_types: Common.retry_policy(policy, :non_retryable_error_types)
          }
        ),
      priority:
        if(priority = initialize_workflow(init, :priority),
          do: %{
            priority_key: priority(priority, :priority_key),
            fairness_key: priority(priority, :fairness_key),
            fairness_weight: priority(priority, :fairness_weight)
          }
        ),
      current_task_build_id: metadata[:current_task_run_id],
      continue_as_new_suggested: metadata[:continue_as_new_suggested],
      continue_as_new_suggested_reasons: metadata[:continue_as_new_suggested_reasons],
      target_worker_deployment_version_changed:
        metadata[:target_worker_deployment_version_changed],
      current_history_size: metadata[:history_size],
      current_history_length: metadata[:history_length],
      current_run_id: metadata[:current_task_run_id]
    )
  end

  @spec get(
          WorkflowContext.t(),
          ActivityActions.activity_handle()
          | TimerActions.timer_handle()
          | ChildWorkflowActions.child_workflow_handle()
        ) ::
          {:ok, term()} | {:error, term()}
  def get(_ctx, ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(_ctx, TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  def get(_ctx, ChildWorkflowActions.child_workflow_handle() = handle),
    do: ChildWorkflowActions.get(handle)

  defmacro __using__(opts) do
    require Temporal.WorkflowContext

    activities = Keyword.get(opts, :activities)

    imports =
      quote do
        import Temporal.Workflow
      end

    activities_section =
      if activities do
        activities =
          Enum.map(activities, fn
            activity when is_atom(activity) ->
              {__CALLER__.module, activity}

            {activity, opts} when is_atom(activity) and is_list(opts) ->
              {__CALLER__.module, activity, opts}
          end)

        quote do
          def _temporal_activities, do: unquote(Macro.escape(activities))
        end
      end

    quote do
      (unquote_splicing([
         imports,
         activities_section
       ]))
    end
  end
end
