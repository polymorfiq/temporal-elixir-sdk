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

  deftype :schedule_local_activity do
    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @type seq :: required :: pos_integer()

    @type activity_id :: required :: String.t()
    @type activity_type :: required :: String.t()

    @doc """
    Local activities can start with a non-1 attempt.

    If lang has been told to backoff using a timer before retrying. It should pass the attempt number from a DoBackoff activity resolution.
    """
    @default 1
    @type attempt :: required :: pos_integer()

    @default %{}
    @type headers :: required :: %{String.t() => Payload.payload()}

    @doc "Arguments/input to the activity."
    @default []
    @type arguments :: required :: [Payload.payload()]

    @doc "If this local activity is a retry (as per the attempt field) this needs to be the original scheduling time (as provided in DoBackoff)"
    @type original_schedule_time :: Timestamp.timestamp()

    @doc "Indicates how long the caller is willing to wait for local activity completion. Limits how long retries will be attempted. When not specified defaults to the workflow execution timeout (which may be unset)."
    @type schedule_to_close_timeout :: Duration.t()

    @doc """
    Limits time the local activity can idle internally before being executed which can happen if the worker is currently at max concurrent local activity executions.

    This timeout is always non retryable as all a retry would achieve is to put it back into the same queue.

    Defaults to schedule_to_close_timeout if not specified and that is set. Must be `<= schedule_to_close_timeout` when set, otherwise, it will be clamped down.
    """
    @type schedule_to_start_timeout :: Duration.t()

    @doc """
    Maximum time the local activity is allowed to execute after the task is dispatched.

    This timeout is always retryable. Either or both of `schedule_to_close_timeout` and this must be specified.

    If set, this must be <= schedule_to_close_timeout, otherwise, it will be clamped down.
    """
    @type start_to_close_timeout :: Duration.t()

    @doc "Specify a retry policy for the local activity. By default local activities will be retried indefinitely."
    @type retry_policy :: Duration.t()

    @doc "If the activity is retrying and backoff would exceed this value, lang will be told to schedule a timer and retry the activity after. Otherwise, backoff will happen internally in core. Defaults to 1 minute."
    @type local_retry_threshold :: Duration.t()

    @doc """
    Defines how the workflow will wait (or not) for cancellation of the activity to be confirmed. Lang should default this to `WAIT_CANCELLATION_COMPLETED`, even though proto will default to `TRY_CANCEL` automatically.
    """
    @default :wait_cancellation_completed
    @type cancellation_type :: TemporalEngine.Data.Commands.cancellation_type()
  end

  deftype :request_cancel_activity do
    @doc "Lang’s incremental sequence number as passed to ScheduleActivity"
    @type seq :: required :: pos_integer()
  end

  deftype :request_cancel_local_activity do
    @doc "Lang’s incremental sequence number as passed to ScheduleLocalActivity"
    @type seq :: required :: pos_integer()
  end

  deftype :complete_workflow_execution do
    @structdoc "Issued when the workflow completes successfully"
    @type result :: Payload.payload()
  end

  deftype :fail_workflow_execution do
    @type failure :: Failure.failure()
  end
end
