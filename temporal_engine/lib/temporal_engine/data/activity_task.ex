defmodule TemporalEngine.Data.ActivityTask do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Common

  alias TemporalEngine.Data.ActivityTask
  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.Timestamp

  deftype :activity_task do
    @type task_token :: required :: String.t()
    @type variant ::
            nested!(ActivityTask.start_activity()) | nested!(ActivityTask.cancel_activity())
  end

  deftype :start_activity do
    @structdoc "Begin executing an activity"

    @doc "The namespace the workflow lives in"
    @type workflow_namespace :: required :: String.t()

    @doc "The workflow’s type name or function identifier"
    @type workflow_type :: required :: String.t()

    @doc "The workflow execution which requested this activity"
    @type workflow_execution :: nested!(Common.workflow_execution())

    @doc "The activity’s ID"
    @type activity_id :: required :: String.t()

    @doc "The activity’s type name or function identifier"
    @type activity_type :: required :: String.t()

    @default %{}
    @type header_fields :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Arguments to the activity"
    @default []
    @type input :: required :: [nested!(Payload.payload())]

    @doc "The last details that were recorded by a heartbeat when this task was generated"
    @default []
    @type heartbeat_details :: [nested!(Payload.payload())]

    @doc "When the task was *first* scheduled"
    @type scheduled_time :: nested!(Timestamp.timestamp())

    @doc "When this current attempt at the task was scheduled"
    @type current_attempt_scheduled_time :: nested!(Timestamp.timestamp())

    @doc "When this attempt was started, which is to say when core received it by polling."
    @type started_time :: nested!(Timestamp.timestamp())

    @type attempt :: pos_integer()

    @doc "Timeout from the first schedule time to completion"
    @type schedule_to_close_timeout :: nested!(Duration.duration())

    @doc "Timeout from starting an attempt to reporting its result"
    @type start_to_close_timeout :: nested!(Duration.duration())

    @doc "If set a heartbeat must be reported within this interval"
    @type heartbeat_timeout :: nested!(Duration.duration())

    @doc "This is an actual retry policy the service uses. It can be different from the one provided (or not) during activity scheduling as the service can override the provided one in case its values are not specified or exceed configured system limits."
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "Priority of this activity. Local activities will always have this field set to the default."
    @type priority :: nested!(Priority.priority())

    @doc "Set to true if this is a local activity. Note that heartbeating does not apply to local activities."
    @type is_local :: required :: bool()

    @doc "Run ID of this activity execution. Only set for standalone activities."
    @default ""
    @type run_id :: required :: String.t()
  end

  deftype :cancel_activity do
    @structdoc "Attempt to cancel a running activity"

    @doc "Primary cancellation reason"
    @type reason :: required :: nested!(ActivityTask.cancel_reason())

    @doc "Activity cancellation details, surfaces all cancellation reasons."
    @type details :: nested!(ActivityTask.cancel_details())
  end

  @type cancel_reason() ::
          :not_found | :cancelled | :timed_out | :worker_shutdown | :paused | :reset

  @type cancel_reason_opts() :: cancel_reason()

  deftype :cancel_details do
    @type is_not_found :: bool()
    @type is_cancelled :: bool()
    @type is_paused :: bool()
    @type is_timed_out :: bool()
    @type is_worker_shutdown :: bool()
    @type is_reset :: bool()
  end
end
