defmodule TemporalEngine.Data.Commands do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Common
  require TemporalEngine.Data.Jobs

  alias TemporalEngine.Data.Commands
  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Jobs
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.Timestamp

  @type command ::
          start_timer()
          | schedule_activity()
          | respond_to_query()
          | request_cancel_activity()
          | cancel_timer()
          | complete_workflow_execution()
          | fail_workflow_execution()
          | continue_as_new_workflow_execution()
          | cancel_workflow_execution()
          | set_patch_marker()
          | start_child_workflow_execution()
          | cancel_child_workflow_execution()
          | request_cancel_external_workflow_execution()
          | signal_external_workflow_execution()
          | schedule_local_activity()
          | request_cancel_local_activity()
          | upsert_workflow_search_attributes()
          | modify_workflow_properties()
          | update_response()
          | schedule_nexus_operation()

  deftype :start_timer do
    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @default :not_specified
    @type seq :: required :: pos_integer() | :not_specified

    @type start_to_fire_timeout :: nested!(Duration.duration())
  end

  deftype :schedule_activity do
    @structdoc """
    Tells Temporal Server that the Workflow needs to execute an Activity to complete its steps.
    """

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @default :not_specified
    @type seq :: required :: pos_integer() | :not_specified

    @default :not_specified
    @type activity_id :: required :: String.t() | :not_specified

    @type activity_type :: required :: String.t()

    @doc "The name of the task queue to place this activity request in"
    @type task_queue :: required :: String.t()

    @doc "These headers represent this, this and this"
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Arguments/input to the activity. Called “input” upstream."
    @default []
    @type arguments :: required :: [nested!(Payload.payload())]

    @doc """
    Indicates how long the caller is willing to wait for an activity completion.
    Limits how long retries will be attempted. Either this or `start_to_close_timeout` must be specified.

    When not specified defaults to the workflow execution timeout.
    """
    @type schedule_to_close_timeout :: nested!(Duration.duration())

    @doc """
    Limits time an activity task can stay in a task queue before a worker picks it up.
    This timeout is always non retryable as all a retry would achieve is to put it back into the same queue.

    Defaults to schedule_to_close_timeout or workflow execution timeout if not specified.
    """
    @type schedule_to_start_timeout :: nested!(Duration.duration())

    @doc """
    Maximum time an activity is allowed to execute after a pick up by a worker. This timeout is always retryable. Either this or schedule_to_close_timeout must be specified.
    """
    @type start_to_close_timeout :: nested!(Duration.duration())

    @doc "Maximum time allowed between successful worker heartbeats."
    @type heartbeat_timeout :: nested!(Duration.duration())

    @doc """
    Activities are provided by a default retry policy controlled through the service dynamic configuration.
    Retries are happening up to schedule_to_close_timeout.

    To disable retries set `retry_policy.maximum_attempts` to 1.
    """
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "Defines how the workflow will wait (or not) for cancellation of the activity to be confirmed"
    @default :try_cancel
    @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon

    @doc """
    If set, the worker will not tell the service that it can immediately start executing this activity.

    When unset/default, workers will always attempt to do so if activity execution slots are available.
    """
    @default false
    @type do_not_eagerly_execute :: bool()

    @doc "Whether this activity should run on a worker with a compatible build id or not."
    @default :unspecified
    @type versioning_intent :: :unspecified | :compatible | :default

    @doc "The Priority to use for this activity"
    @type priority :: nested!(Priority.priority())
  end

  deftype :respond_to_query do
    @doc "Corresponds to the id provided in the activation job"
    @type query_id :: required :: String.t()

    @type variant :: required :: nested!(Commands.query_success()) | nested!(Failure.failure())
  end

  deftype :query_success do
    @type response :: Payload.payload()
  end

  deftype :request_cancel_activity do
    @doc "Lang’s incremental sequence number as passed to `schedule_activity`"
    @type seq :: required :: pos_integer()
  end

  deftype :cancel_timer do
    @doc "Lang’s incremental sequence number as passed to `start_timer`"
    @type seq :: required :: pos_integer()
  end

  deftype :complete_workflow_execution do
    @structdoc "Issued when the workflow completes successfully"
    @type result :: nested!(Payload.payload())
  end

  deftype :fail_workflow_execution do
    @type failure :: nested!(Failure.failure())
  end

  deftype :continue_as_new_workflow_execution do
    @doc "The identifier the lang-specific sdk uses to execute workflow code"
    @type workflow_type :: required :: String.t()

    @doc "Task queue for the new workflow execution"
    @type task_queue :: required :: String.t()

    @doc "Inputs to the workflow code. Should be specified. Will not re-use old arguments, as that typically wouldn’t make any sense."
    @type arguments :: required :: [nested!(Payload.payload())]

    @doc "Timeout for a single run of the new workflow. Will not re-use current workflow’s value."
    @type workflow_run_timeout :: nested!(Duration.duration())

    @doc "Timeout of a single workflow task. Will not re-use current workflow’s value."
    @type workflow_task_timeout :: nested!(Duration.duration())

    @doc "If set, the new workflow will have this memo. If unset, re-uses the current workflow’s memo"
    @default %{}
    @type memo :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "If set, the new workflow will have these headers. Will not re-use current workflow’s headers otherwise."
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "If set, the new workflow will have these search attributes. If unset, re-uses the current workflow’s search attributes."
    @type search_attributes :: nested!(Jobs.search_attribs())

    @doc "If set, the new workflow will have this retry policy. If unset, re-uses the current workflow’s retry policy."
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "Whether the continued workflow should run on a worker with a compatible build id or not."
    @default :unspecified
    @type versioning_intent :: :unspecified | :compatible | :default

    @doc "Experimental. Optionally decide the versioning behavior that the first task of the new run should use. For example, choose to AutoUpgrade on continue-as-new instead of inheriting the pinned version of the previous run."
    @default :unspecified
    @type initial_versioning_behavior ::
            required :: :unspecified | :auto_upgrade | :use_ramping_version

    @doc "Delay before the first workflow task of the continued run is scheduled."
    @type backoff_start_interval :: nested!(Duration.duration)
  end

  deftype :cancel_workflow_execution do
    @structdoc "Indicate a workflow has completed as cancelled. Generally sent as a response to an activation containing a cancellation job."
  end

  deftype :set_patch_marker do
    @structdoc "A request to set/check if a certain patch is present or not"

    @doc """
    A user-chosen identifier for this patch.

    If the same identifier is used in multiple places in the code, those places are considered to be versioned as one unit.

    IE: The check call will return the same result for all of them
    """
    @type patch_id :: required :: String.t()

    @doc """
    Can be set to true to indicate that branches using this change are being removed, and all future worker deployments will only have the “with change” code in them.
    """
    @default false
    @type deprecated :: required :: boolean()
  end

  deftype :start_child_workflow_execution do
    @structdoc "Start a child workflow execution"

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @default :not_specified
    @type seq :: required :: pos_integer() | :not_specified

    @type namespace :: required :: String.t()
    @type id :: required :: String.t()
    @type workflow_type :: required :: String.t()
    @type task_queue :: required :: String.t()

    @default []
    @type input :: required :: [nested!(Payload.payload())]

    @doc "Total workflow execution timeout including retries and continue as new."
    @type workflow_execution_timeout :: nested!(Duration.duration())

    @doc "Timeout of a single workflow run."
    @type workflow_run_timeout :: nested!(Duration.duration())

    @doc "Timeout of a single workflow task."
    @type workflow_task_timeout :: nested!(Duration.duration())

    @doc """
    Used by the service to determine the fate of a child workflow in case its parent is closed.

    Options:
    - `:unspecified` - Let’s the server set the default.
    - `:terminate` - Terminate means terminating the child workflow.
    - `:abandon` - Abandon means not doing anything on the child workflow.
    - `:request_cancel` - Cancel means requesting cancellation on the child workflow.
    """
    @default :terminate
    @type parent_close_policy ::
            required :: :unspecified | :terminate | :abandon | :request_cancel

    @doc """
    Defines whether to allow re-using a workflow id from a previously closed workflow. If the request is denied, the server returns a `WorkflowExecutionAlreadyStartedFailure` error.

    See `workflow_id_conflict_policy` for handling workflow id duplication with a running workflow.
    `:allow_duplicate` - Allow starting a workflow execution using the same workflow id.
    `:allow_duplicate_failed_only` - Allow starting a workflow execution using the same workflow id, only when the last execution’s final state is one of [`terminated`, `cancelled`, `timed out`, `failed`].
    `:reject_duplicate` - Do not permit re-use of the workflow id for this workflow. Future start workflow requests could potentially change the policy, allowing re-use of the workflow id.

    `:terminate_if_running` - Terminate the current Workflow if one is already running; otherwise allow reusing the Workflow ID. When using this option, `workflow_id_conflict_policy` must be left unspecified.
                            - **Deprecated.** Instead, set `workflow_id_reuse_policy` to `:allow_duplicate` and `workflow_id_conflict_policy` to `:terminate_existing`. Note that `workflow_id_conflict_policy` requires Temporal Server v1.24.0 or later.
    """
    @default :unspecified
    @type workflow_id_reuse_policy ::
            required ::
            :unspecified
            | :allow_duplicate
            | :allow_duplicate_failed_only
            | :reject_duplicate
            | :terminate_if_running

    @doc "How retries ought to be handled, usable by both workflows and activities"
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "Optionally set a cron schedule for the workflow"
    @default ""
    @type cron_schedule :: required :: String.t()

    @doc "Header fields"
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Memo fields"
    @default %{}
    @type memo :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Search attributes"
    @type search_attributes :: nested!(Jobs.search_attribs())

    @doc """
    Defines behaviour of the underlying workflow when child workflow cancellation has been requested.

    - `:abandon` - Do not request cancellation of the child workflow if already scheduled
    - `:try_cancel` - Initiate a cancellation request and immediately report cancellation to the parent.
    - `:wait_cancellation_completed` - Wait for child cancellation completion.
    - `:wait_cancellation_requested` - Request cancellation of the child and wait for confirmation that the request was received.
    """
    @default :wait_cancellation_completed
    @type cancellation_type ::
            required ::
            :abandon | :try_cancel | :wait_cancellation_completed | :wait_cancellation_requested

    @doc """
    Whether this child should run on a worker with a compatible build id or not.

    - `:unspecified` - Indicates that core should choose the most sensible default behavior for the type of command, accounting for whether the command will be run on the same task queue as the current worker.
    - `:compatible` - Indicates that the command should run on a worker with compatible version if possible. It may not be possible if the target task queue does not also have knowledge of the current worker’s build ID.
    - `:default` - Indicates that the command should run on the target task queue’s current overall-default build ID.
    """
    @default :unspecified
    @type versioning_intent :: required :: :unspecified | :compatible | :default

    @doc "The Priority to use for this activity"
    @type priority :: nested!(Priority.priority())
  end

  deftype :cancel_child_workflow_execution do
    @structdoc "Cancel a child workflow"

    @doc "Sequence number as given to the `start_workflow_execution` command"
    @type child_workflow_seq :: required :: pos_integer()

    @doc "A reason for the cancellation"
    @type reason :: required :: String.t()
  end

  deftype :request_cancel_external_workflow_execution do
    @structdoc """
    Request cancellation of an external workflow execution.

    For cancellation of a child workflow, prefer `cancel_child_workflow_execution` instead, as it guards against cancel-before-start issues.
    """

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @type seq :: required :: pos_integer()

    @doc "The workflow instance being targeted"
    @type workflow_execution :: nested!(Common.namespaced_workflow_execution())

    @doc "A reason for the cancellation"
    @type reason :: required :: String.t()
  end

  deftype :signal_external_workflow_execution do
    @structdoc "Send a signal to an external or child workflow"

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @type seq :: required :: pos_integer()

    @doc "Name of the signal handler"
    @type signal_handler :: required :: String.t()

    @doc "Arguments for the handler"
    @default []
    @type args :: required :: [nested!(Payload.payload())]

    @doc "Headers to attach to the signal"
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "What workflow is being targeted"
    @type target ::
            nested!(Common.namespaced_workflow_execution())
            | nested!(Commands.child_workflow_target())
  end

  deftype :child_workflow_target do
    @type workflow_id :: required :: String.t()
  end

  deftype :cancel_signal_workflow do
    @structdoc "Can be used to cancel not-already-sent `signal_external_workflow_execution` commands"

    @doc "Lang’s incremental sequence number as passed to `signal_external_workflow_execution`"
    @type seq :: required :: pos_integer()
  end

  deftype :schedule_local_activity do
    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @default :not_specified
    @type seq :: required :: pos_integer() | :not_specified

    @default :not_specified
    @type activity_id :: required :: String.t() | :not_specified
    @type activity_type :: required :: String.t()

    @doc """
    Local activities can start with a non-1 attempt.

    If lang has been told to backoff using a timer before retrying. It should pass the attempt number from a DoBackoff activity resolution.
    """
    @default 1
    @type attempt :: required :: pos_integer()

    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Arguments/input to the activity."
    @default []
    @type arguments :: required :: [nested!(Payload.payload())]

    @doc "If this local activity is a retry (as per the attempt field) this needs to be the original scheduling time (as provided in DoBackoff)"
    @type original_schedule_time :: nested!(Timestamp.timestamp())

    @doc "Indicates how long the caller is willing to wait for local activity completion. Limits how long retries will be attempted. When not specified defaults to the workflow execution timeout (which may be unset)."
    @type schedule_to_close_timeout :: nested!(Duration.duration())

    @doc """
    Limits time the local activity can idle internally before being executed which can happen if the worker is currently at max concurrent local activity executions.

    This timeout is always non retryable as all a retry would achieve is to put it back into the same queue.

    Defaults to schedule_to_close_timeout if not specified and that is set. Must be `<= schedule_to_close_timeout` when set, otherwise, it will be clamped down.
    """
    @type schedule_to_start_timeout :: nested!(Duration.duration())

    @doc """
    Maximum time the local activity is allowed to execute after the task is dispatched.

    This timeout is always retryable. Either or both of `schedule_to_close_timeout` and this must be specified.

    If set, this must be <= schedule_to_close_timeout, otherwise, it will be clamped down.
    """
    @type start_to_close_timeout :: nested!(Duration.duration())

    @doc "Specify a retry policy for the local activity. By default local activities will be retried indefinitely."
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "If the activity is retrying and backoff would exceed this value, lang will be told to schedule a timer and retry the activity after. Otherwise, backoff will happen internally in core. Defaults to 1 minute."
    @type local_retry_threshold :: nested!(Duration.duration())

    @doc """
    Defines how the workflow will wait (or not) for cancellation of the activity to be confirmed. Lang should default this to `WAIT_CANCELLATION_COMPLETED`, even though proto will default to `TRY_CANCEL` automatically.
    """
    @default :wait_cancellation_completed
    @type cancellation_type :: :try_cancel | :wait_cancellation_completed | :abandon
  end

  deftype :request_cancel_local_activity do
    @doc "Lang’s incremental sequence number as passed to `schedule_local_activity`"
    @type seq :: required :: pos_integer()
  end

  deftype :upsert_workflow_search_attributes do
    @doc "`search_attributes` to upsert. The indexed_fields map will be merged with existing search attributes, with these values taking precedence."
    @type search_attributes :: nested!(Jobs.search_attribs())
  end

  deftype :modify_workflow_properties do
    @doc """
    If set, update the workflow memo with the provided values. The values will be merged with the existing memo.

    If the user wants to delete values, a default/empty Payload should be used as the value for the key being deleted.
    """
    @type upserted_memo :: nested!(Jobs.memo())
  end

  deftype :update_response do
    @structdoc """
    A reply to a do_update job - lang must run the update’s validator if told to, and then immediately run the handler, if the update was accepted.

    There must always be an accepted or rejected response immediately, in the same activation as this job, to indicate the result of the validator. Accepted for ran and accepted or skipped, or rejected for rejected.

    Then, in the same or any subsequent activation, after the update handler has completed, respond with completed or rejected as appropriate for the result of the handler.
    """

    @doc "The protocol message instance ID"
    @type protocol_instance_id :: required :: String.t()

    @type response ::
            nested!(Commands.update_accepted())
            | nested!(Commands.update_rejected())
            | nested!(Commands.update_completed())
  end

  deftype :update_accepted do
    @structdoc "Must be sent if the update’s validator has passed (or lang was not asked to run it, and thus should be considered already-accepted, allowing lang to always send the same sequence on replay)."

    @default {}
    @type response :: tuple()
  end

  deftype :update_rejected do
    @structdoc "Must be sent if the update’s validator does not pass, or after acceptance if the update handler fails."

    @type failure :: required :: nested!(Failure.failure())
  end

  deftype :update_completed do
    @structdoc "Must be sent once the update handler completes successfully."

    @type payload :: required :: nested!(Payload.payload())
  end

  deftype :schedule_nexus_operation do
    @structdoc "A request to begin a Nexus operation"

    @doc "Lang’s incremental sequence number, used as the operation identifier"
    @default :not_specified
    @type seq :: required :: pos_integer() | :not_specified

    @doc "Endpoint name, must exist in the endpoint registry or this command will fail."
    @type endpoint :: required :: String.t()

    @doc "Service name."
    @type service :: required :: String.t()

    @doc "Operation name."
    @type operation :: required :: String.t()

    @doc """
    Input for the operation.

    The server converts this into Nexus request content and the appropriate content headers internally when sending the StartOperation request.

    On the handler side, if it is also backed by Temporal, the content is transformed back to the original Payload sent in this command.
    """
    @type input :: nested!(Payload.payload())

    @doc "Schedule-to-close timeout for this operation. Indicates how long the caller is willing to wait for operation completion. Calls are retried internally by the server."
    @type schedule_to_close_timeout :: nested!(Duration.duration())

    @doc """
    Header to attach to the Nexus request. Users are responsible for encrypting sensitive data in this header as it is stored in workflow history and transmitted to external services as-is.

    This is useful for propagating tracing information.

    Note these headers are not the same as Temporal headers on internal activities and child workflows, these are transmitted to Nexus operations that may be external and are not traditional payloads.
    """
    @default %{}
    @type nexus_header :: %{String.t() => String.t()}

    @doc """
    Defines behaviour of the underlying nexus operation when operation cancellation has been requested.

    - `:wait_cancellation_completed` - Wait for operation cancellation completion.
    - `:abandon` - Do not request cancellation of the nexus operation if already scheduled
    - `:try_cancel` - Initiate a cancellation request for the Nexus operation and immediately report cancellation to the caller. Note that it doesn’t guarantee that cancellation is delivered to the operation if calling workflow exits before the delivery is done. If you want to ensure that cancellation is delivered to the operation, use `:wait_cancellation_requested`.
    - `:wait_cancellation_requested` - Request cancellation of the operation and wait for confirmation that the request was received.
    """
    @default :wait_cancellation_completed
    @type cancellation_type ::
            required ::
            :wait_cancellation_completed | :abandon | :try_cancel | :wait_cancellation_requested

    @doc """
    Schedule-to-start timeout for this operation. Indicates how long the caller is willing to wait for the operation to be started (or completed if synchronous) by the handler.

    If the operation is not started within this timeout, it will fail with TIMEOUT_TYPE_SCHEDULE_TO_START. If not set or zero, no schedule-to-start timeout is enforced.
    """
    @type schedule_to_start_timeout :: nested!(Duration.duration())

    @doc """
    Start-to-close timeout for this operation. Indicates how long the caller is willing to wait for an asynchronous operation to complete after it has been started.

    If the operation does not complete within this timeout after starting, it will fail with TIMEOUT_TYPE_START_TO_CLOSE. Only applies to asynchronous operations. Synchronous operations ignore this timeout. If not set or zero, no start-to-close timeout is enforced.
    """
    @type start_to_close_timeout :: nested!(Duration.duration())
  end

  deftype :request_cancel_nexus_operation do
    @doc "Lang’s incremental sequence number as passed to `schedule_nexus_operation`"
    @type seq :: required :: pos_integer()
  end
end
