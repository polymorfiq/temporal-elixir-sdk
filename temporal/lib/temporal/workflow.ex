defmodule Temporal.Workflow do
  require Temporal.Workflow.ActivityActions
  require Temporal.Workflow.TimerActions
  require TemporalEngine.Data.Failure

  alias Temporal.Workflow.ActivityActions
  alias Temporal.Workflow.TimerActions
  alias TemporalEngine.WorkflowHandle
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  defdelegate execute_activity(ctx, name, inputs, opts \\ []), to: ActivityActions
  defdelegate new_timer(ctx, duration), to: TimerActions

  def get(ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  def get(_ctx, ActivityActions.activity_handle() = handle),
    do: ActivityActions.get(handle)

  def get(_ctx, TimerActions.timer_handle() = handle),
    do: TimerActions.get(handle)

  def query_handler(_ctx, _name, _handler) do
    {:error, :not_implemented}
  end

  @spec result(WorkflowHandle.t(), opts :: keyword()) :: {:ok, term()} | {:error, term()}
  def result(handle, opts \\ []) do
    case WorkflowHandle.get_result(handle, opts) do
      {:ok, resp} ->
        {:ok, resp}

      {:error,
       Failure.workflow_failed(
         failure:
           Failure.failure(
             failure_info: Failure.application(failure_type: "ReturnedError", details: [resp_payload])
           )
       )} ->
        {:error, Payload.value_from_record(resp_payload)}

      {:error, Failure.workflow_failed(failure: f)} ->
        {:error, %{message: Failure.failure(f, :message), source: Failure.failure(f, :source), stacktrace: Failure.failure(f, :stack_trace), cause: Failure.failure(f, :cause), info: Failure.failure(f, :failure_info)}}

      {:error, err} ->
        {:error, err |> IO.inspect(label: "my-error")}
    end
  end

  defmacro __using__(opts) do
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
