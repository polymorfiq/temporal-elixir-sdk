defmodule TemporalEngine.Data.ActivityTask do
  require Record

  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy
  alias TemporalEngine.Data.Timestamp

  @type activity_task :: start_activity() | cancel_activity()

  Record.defrecord(:start_activity, [
    :activity_type,
    :activity_id,
    :workflow_type,
    :workflow_namespace,
    :header_fields,
    :input,
    :heartbeat_details,
    :attempt,
    :is_local,
    :run_id,
    :task_token,
    workflow_execution: nil,
    scheduled_time: nil,
    current_attempt_scheduled_time: nil,
    started_time: nil,
    schedule_to_close_timeout: nil,
    start_to_close_timeout: nil,
    heartbeat_timeout: nil,
    retry_policy: nil,
    priority: nil
  ])

  @type start_activity ::
          record(:start_activity,
            workflow_namespace: String.t(),
            activity_id: String.t(),
            activity_type: String.t(),
            run_id: String.t(),
            workflow_type: String.t(),
            workflow_execution: run() | nil,
            header_fields: map(),
            input: [Payload.payload()],
            heartbeat_details: [Payload.payload()],
            scheduled_time: Timestamp.timestamp() | nil,
            current_attempt_scheduled_time: Timestamp.timestamp() | nil,
            started_time: Timestamp.timestamp() | nil,
            attempt: pos_integer(),
            schedule_to_close_timeout: Duration.duration() | nil,
            start_to_close_timeout: Duration.duration() | nil,
            heartbeat_timeout: Duration.duration() | nil,
            retry_policy: RetryPolicy.policy() | nil,
            priority: Priority.priority(),
            is_local: bool(),
            task_token: binary()
          )

  Record.defrecord(:run, [:workflow_id, :run_id])
  @type run :: record(:run, workflow_id: String.t(), run_id: String.t())

  Record.defrecord(:cancel_activity, [:reason, details: nil, task_token: nil])
  @type cancel_activity :: record(:cancel_activity, reason: cancel_reason(), task_token: binary(),)

  @type cancel_reason() ::
          :not_found | :cancelled | :timed_out | :worker_shutdown | :paused | :reset

  Record.defrecord(:details, [
    :is_not_found,
    :is_cancelled,
    :is_paused,
    :is_timed_out,
    :is_worker_shutdown,
    :is_reset
  ])

  @type details ::
          record(:details,
            is_not_found: bool(),
            is_cancelled: bool(),
            is_paused: bool(),
            is_timed_out: bool(),
            is_worker_shutdown: bool(),
            is_reset: bool()
          )
end
