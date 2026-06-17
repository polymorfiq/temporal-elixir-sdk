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

  deftype :schedule_activity do
    @structdoc """
    Tells Temporal Server that the Workflow needs to execute an Activity to complete its steps.
    """

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @type seq :: required :: pos_integer()

    @type activity_id :: required :: String.t()

    @type activity_type :: required :: String.t()

    @doc "The name of the task queue to place this activity request in"
    @type task_queue :: required :: String.t()

    @doc "These headers represent this, this and this"
    @default %{}
    @type headers :: required :: %{String.t() => Payload.payload()}

    @doc "Arguments/input to the activity. Called “input” upstream."
    @default []
    @type arguments :: required :: [Payload.payload()]

    @doc """
    Indicates how long the caller is willing to wait for an activity completion.
    Limits how long retries will be attempted. Either this or `start_to_close_timeout` must be specified.

    When not specified defaults to the workflow execution timeout.
    """
    @type schedule_to_close_timeout :: Duration.t()

    @doc """
    Limits time an activity task can stay in a task queue before a worker picks it up.
    This timeout is always non retryable as all a retry would achieve is to put it back into the same queue.

    Defaults to schedule_to_close_timeout or workflow execution timeout if not specified.
    """
    @type schedule_to_start_timeout :: Duration.t()

    @doc """
    Maximum time an activity is allowed to execute after a pick up by a worker. This timeout is always retryable. Either this or schedule_to_close_timeout must be specified.
    """
    @type start_to_close_timeout :: Duration.t()

    @doc "Maximum time allowed between successful worker heartbeats."
    @type heartbeat_timeout :: Duration.t()

    @doc """
    Activities are provided by a default retry policy controlled through the service dynamic configuration.
    Retries are happening up to schedule_to_close_timeout.

    To disable retries set `retry_policy.maximum_attempts` to 1.
    """
    @type retry_policy :: RetryPolicy.policy()

    @doc "Defines how the workflow will wait (or not) for cancellation of the activity to be confirmed"
    @default :try_cancel
    @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon

    @doc """
    If set, the worker will not tell the service that it can immediately start executing this activity.

    When unset/default, workers will always attempt to do so if activity execution slots are available.
    """
    @type do_not_eagerly_execute :: bool()

    @doc "Whether this activity should run on a worker with a compatible build id or not."
    @default :unspecified
    @type versioning_intent :: :unspecified | :compatible | :default

    @doc "The Priority to use for this activity"
    @type priority :: Priority.priority()
  end

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

  deftype :fail_workflow_execution do
    @type failure :: Failure.failure()
  end
end
