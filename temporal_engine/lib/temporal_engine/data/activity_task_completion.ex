defmodule TemporalEngine.Data.ActivityTaskCompletion do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.ActivityTaskCompletion
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload

  deftype :task_completion do
    @structdoc "A request as given to `complete_activity_task`"

    @type task_token :: required :: [byte()]
    @type result :: nested!(ActivityTaskCompletion.activity_execution_result())
  end

  deftype :activity_execution_result do
    @structdoc "Used to report activity completions to core"

    @type status ::
            nested!(ActivityTaskCompletion.activity_completed())
            | nested!(ActivityTaskCompletion.activity_failed())
            | nested!(ActivityTaskCompletion.activity_cancelled())
            | nested!(ActivityTaskCompletion.activity_will_complete_async())
  end

  deftype :activity_completed do
    @structdoc "Used to report successful completion either when executing or resolving"

    @type result :: nested!(Payload.payload())
  end

  deftype :activity_failed do
    @structdoc "Used to report activity failure either when executing or resolving"

    @type failure :: nested!(Failure.failure())
  end

  deftype :activity_cancelled do
    @structdoc """
    Used to report cancellation from both Core and Lang.

    When Lang reports a cancelled activity, it must put a CancelledFailure in the failure field.

    When Core reports a cancelled activity, it must put an ActivityFailure with CancelledFailure as the cause in the failure field.
    """

    @type failure :: nested!(Failure.failure())
  end

  deftype :activity_will_complete_async do
    @structdoc """
    Used in ActivityExecutionResult to notify Core that this Activity will complete asynchronously.

    Core will forget about this Activity and free up resources used to track this Activity.
    """
  end
end
