defmodule TemporalEngine.Data.Commands do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy
  alias TemporalEngine.Data.Timestamp

  @type command ::
          start_timer()
          | schedule_activity()
          | request_cancel_activity()
          | complete_workflow_execution()
          | fail_workflow_execution()
          | schedule_local_activity()
          | request_cancel_local_activity()

  Record.defrecord(:start_timer, [:seq, :start_to_fire_timeout])

  @type start_timer ::
          record(:start_timer, seq: pos_integer(), start_to_fire_timeout: Duration.t())

  deftype :my_schedule_activity do
    @required true
    @type seq :: pos_integer()

    @required true
    @type activity_id :: String.t()

    @required true
    @type activity_type :: String.t()

    @required true
    @type task_queue :: String.t()

    @required true
    @type headers :: %{String.t() => Payload.payload()}

    @required true
    @type arguments :: [Payload.payload()]

    @type schedule_to_close_timeout :: Duration.t()
    @type schedule_to_start_timeout :: Duration.t()
    @type start_to_close_timeout :: Duration.t()
    @type heartbeat_timeout :: Duration.t()
    @type retry_policy :: RetryPolicy.policy()
    @type cancellation_type :: cancellation_type()
    @type do_not_eagerly_execute :: bool()
    @type versioning_intent :: versioning_intent()
    @type priority :: Priority.priority()
  end

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
            seq: pos_integer(),
            activity_id: String.t(),
            activity_type: String.t(),
            task_queue: String.t(),
            headers: %{String.t() => Payload.payload()},
            arguments: [Payload.payload()],
            schedule_to_close_timeout: Duration.t() | nil,
            schedule_to_start_timeout: Duration.t() | nil,
            start_to_close_timeout: Duration.t() | nil,
            heartbeat_timeout: Duration.t() | nil,
            retry_policy: RetryPolicy.policy() | nil,
            cancellation_type: cancellation_type(),
            do_not_eagerly_execute: bool(),
            versioning_intent: versioning_intent(),
            priority: Priority.priority() | nil
          )

  @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  @type versioning_intent :: :unspecified | :compatible | :default

  Record.defrecord(:request_cancel_activity, [:seq])
  @type request_cancel_activity :: record(:request_cancel_activity, seq: pos_integer())

  Record.defrecord(:schedule_local_activity, [
    :seq,
    :activity_id,
    :activity_type,
    attempt: 1,
    original_schedule_time: nil,
    headers: %{},
    arguments: [],
    schedule_to_close_timeout: nil,
    schedule_to_start_timeout: nil,
    start_to_close_timeout: nil,
    retry_policy: nil,
    local_retry_threshold: nil,
    cancellation_type: :wait_cancellation_completed
  ])

  @type schedule_local_activity ::
          record(:schedule_local_activity,
            seq: pos_integer(),
            activity_id: String.t(),
            activity_type: String.t(),
            attempt: pos_integer(),
            original_schedule_time: Timestamp.timestamp() | nil,
            headers: %{String.t() => Payload.payload()},
            arguments: [Payload.payload()],
            schedule_to_close_timeout: Duration.t() | nil,
            schedule_to_start_timeout: Duration.t() | nil,
            start_to_close_timeout: Duration.t() | nil,
            retry_policy: RetryPolicy.policy() | nil,
            local_retry_threshold: Duration.t() | nil,
            cancellation_type: cancellation_type()
          )

  Record.defrecord(:request_cancel_local_activity, [:seq])

  @type request_cancel_local_activity ::
          record(:request_cancel_local_activity, seq: pos_integer())

  Record.defrecord(:complete_workflow_execution, result: nil)

  @type complete_workflow_execution ::
          record(:complete_workflow_execution, result: Payload.payload() | nil)

  Record.defrecord(:fail_workflow_execution, failure: nil)

  @type fail_workflow_execution ::
          record(:fail_workflow_execution, failure: Failure.failure() | nil)
end
