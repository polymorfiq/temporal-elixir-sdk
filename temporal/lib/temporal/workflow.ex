defmodule Temporal.Workflow do
  require Temporal.Workflow.ActivityActions
  require Temporal.Workflow.TimerActions
  require Temporal.Workflow.WorkflowContext
  require TemporalEngine.Data.Failure

  alias Temporal.Workflow.ActivityActions
  alias Temporal.Workflow.TimerActions
  alias Temporal.Workflow.WorkflowContext
  alias Temporal.Workflow.WorkflowExecution
  alias TemporalEngine.WorkflowHandle
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  defdelegate execute_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate execute_local_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate new_timer(ctx, duration), to: TimerActions
  defdelegate sleep(ctx, duration), to: TimerActions

  @spec get(ActivityActions.activity_handle() | TimerActions.timer_handle()) :: {:ok, term()} | {:error, term()}
  def get(ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  @spec get(WorkflowContext.t(), ActivityActions.activity_handle() | TimerActions.timer_handle()) :: {:ok, term()} | {:error, term()}
  def get(_ctx, ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(_ctx, TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  @spec set_query_handler(WorkflowContext.t(), name :: atom() | String.t(), handler :: fun()) :: :ok
  def set_query_handler(ctx, name, handler) do
    exec = WorkflowContext.workflow_context(ctx, :execution)
    WorkflowExecution.set_query_handler(exec, "#{name}", handler)
  end

  @spec result(WorkflowHandle.t(), opts :: keyword()) :: {:ok, term()} | {:error, term()}
  def result(handle, opts \\ []) do
    case WorkflowHandle.get_result(handle, opts) do
      {:ok, resp} ->
        {:ok, Payload.value_from_record(resp)}

      {:error,
       Failure.workflow_failed(
         failure:
           Failure.failure(
             failure_info:
               Failure.application(failure_type: "ReturnedError", details: [resp_payload])
           )
       )} ->
        {:error, Payload.value_from_record(resp_payload)}

      {:error, Failure.workflow_failed(failure: f)} ->
        {:error, Failure.to_map(f) |> Map.put(:error_code, :workflow_failed)}

      {:error, Failure.workflow_cancelled(details: details)} ->
        {:error,
         %{
           error_code: :workflow_cancelled,
           details: Enum.map(details, &Payload.value_from_record/1)
         }}

      {:error, Failure.workflow_terminated(details: details)} ->
        {:error,
         %{
           error_code: :workflow_terminated,
           details: Enum.map(details, &Payload.value_from_record/1)
         }}

      {:error, Failure.workflow_timed_out()} ->
        {:error, %{error_code: :workflow_timed_out}}

      {:error, Failure.workflow_continued_as_new()} ->
        {:error, %{error_code: :workflow_continued_as_new}}

      {:error, Failure.workflow_not_found()} ->
        {:error, %{error_code: :workflow_not_found}}

      {:error, Failure.workflow_payload_conversion(message: message)} ->
        {:error, %{error_code: :workflow_payload_conversion, message: message}}

      {:error, Failure.workflow_rpc_error(message: message)} ->
        {:error, %{error_code: :workflow_rpc_error, message: message}}

      {:error, Failure.workflow_other_error(message: message)} ->
        {:error, %{error_code: :workflow_other_error, message: message}}

      {:error, err} ->
        {:error, err}
    end
  end

  defmacro __using__(opts) do
    require Temporal.Workflow.WorkflowContext

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
