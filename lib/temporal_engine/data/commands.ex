defmodule TemporalEngine.Data.Commands do
  require Record

  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy

  @type command ::
          start_timer()
          | schedule_activity()
          | complete_workflow_execution()
          | fail_workflow_execution()

  Record.defrecord(:start_timer, [:seq, :start_to_fire_timeout])

  @type start_timer ::
          record(:start_timer, seq: pos_integer(), start_to_fire_timeout: Duration.duration())

  Record.defrecord(:schedule_activity, [
    :seq,
    :activity_id,
    :activity_type,
    :task_queue,
    arguments: [],
    cancellation_type: :try_cancel,
    do_not_eagerly_execute: false,
    headers: %{},
    versioning_intent: :unspecified,
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ])

  @type schedule_activity ::
          record(:schedule_activity,
            activity_id: String.t(),
            activity_type: String.t(),
            task_queue: String.t(),
            headers: %{String.t() => Payload.payload()},
            arguments: [Payload.payload()],
            schedule_to_close_timeout: Duration.duration() | nil,
            schedule_to_start_timeout: Duration.duration() | nil,
            start_to_close_timeout: Duration.duration() | nil,
            heartbeat_timeout: Duration.duration() | nil,
            retry_policy: RetryPolicy.policy() | nil,
            cancellation_type: cancellation_type(),
            do_not_eagerly_execute: bool(),
            versioning_intent: versioning_intent(),
            priority: Priority.priority() | nil
          )

  @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  @type versioning_intent :: :unspecified | :compatible | :default

  Record.defrecord(:complete_workflow_execution, result: nil)

  @type complete_workflow_execution ::
          record(:complete_workflow_execution, result: Payload.payload() | nil)

  Record.defrecord(:fail_workflow_execution, failure: nil)

  @type fail_workflow_execution ::
          record(:fail_workflow_execution, failure: Failure.failure() | nil)
end
