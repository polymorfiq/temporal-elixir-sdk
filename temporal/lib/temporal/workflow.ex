defmodule Temporal.Workflow do
  require Temporal.Workflow.ActivityActions
  require Temporal.Workflow.TimerActions
  require Temporal.WorkflowContext
  require TemporalEngine.Data.Commands

  alias Temporal.Workflow.ActivityActions
  alias Temporal.Workflow.TimerActions
  alias Temporal.WorkflowContext
  alias Temporal.Workflow.WorkflowExecution
  alias TemporalEngine.Data.Commands

  defdelegate execute_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_local_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate new_timer(ctx, duration), to: TimerActions
  defdelegate sleep(ctx, duration), to: TimerActions

  @spec with_activity_opts(
          WorkflowContext.t(),
          activity_opts :: Commands.schedule_activity_opts()
        ) :: WorkflowContext.t()
  def with_activity_opts(ctx, opts) do
    existing_opts = WorkflowContext.workflow_context(ctx, :activity_options)
    WorkflowContext.workflow_context(ctx, activity_options: existing_opts ++ opts)
  end

  @spec get(WorkflowContext.t(), ActivityActions.activity_handle() | TimerActions.timer_handle()) ::
          {:ok, term()} | {:error, term()}
  def get(_ctx, ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(_ctx, TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  @spec set_query_handler(WorkflowContext.t(), name :: atom() | String.t(), handler :: fun()) ::
          :ok
  def set_query_handler(ctx, name, handler) do
    exec = WorkflowContext.workflow_context(ctx, :execution)
    WorkflowExecution.set_query_handler(exec, "#{name}", handler)
  end

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
