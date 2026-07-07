defmodule TemporalEngine.Data.Jobs do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Common

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.Timestamp
  alias TemporalEngine.Data.Jobs

  deftype :job do
    @type variant ::
            nested!(Jobs.initialize_workflow())
            | nested!(Jobs.fire_timer())
            | nested!(Jobs.update_random_seed())
            | nested!(Jobs.query_workflow())
            | nested!(Jobs.cancel_workflow())
            | nested!(Jobs.signal_workflow())
            | nested!(Jobs.resolve_activity())
            | nested!(Jobs.notify_has_patch())
            | nested!(Jobs.resolve_child_workflow_execution_start())
            | nested!(Jobs.resolve_child_workflow_execution())
            | nested!(Jobs.resolve_signal_external_workflow())
            | nested!(Jobs.resolve_request_cancel_external_workflow())
            | nested!(Jobs.do_update())
            | nested!(Jobs.resolve_nexus_operation_start())
            | nested!(Jobs.resolve_nexus_operation())
            | nested!(Jobs.remove_from_cache())
  end

  deftype :initialize_workflow do
    @structdoc "Initialize a new workflow"

    @doc "The identifier the lang-specific sdk uses to execute workflow code"
    @type workflow_type :: required :: String.t()

    @doc "The workflow id used on the temporal server"
    @type workflow_id :: required :: String.t()

    @doc "Inputs to the workflow code"
    @default []
    @type arguments :: required :: [nested!(Payload.payload())]

    @doc "The seed must be used to initialize the random generator used by SDK. `RandomSeedUpdatedAttributes` are used to deliver seed updates."
    @type randomness_seed :: required :: pos_integer()

    @doc "Used to add metadata e.g. for tracing and auth, meant to be read and written to by interceptors."
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Identity of the client who requested this execution"
    @type identity :: required :: String.t()

    @doc "If this workflow is a child, information about the parent"
    @type parent_workflow_info :: nested!(Common.namespaced_workflow_execution())

    @doc "Total workflow execution timeout including retries and continue as new."
    @type workflow_execution_timeout :: nested!(Duration.duration())

    @doc "Timeout of a single workflow run."
    @type workflow_run_timeout :: nested!(Duration.duration())

    @doc "Timeout of a single workflow task."
    @type workflow_task_timeout :: nested!(Duration.duration())

    @doc "Run id of the previous workflow which continued-as-new or retried or cron executed into this workflow, if any."
    @type continued_from_execution_run_id :: required :: String.t()

    @doc "If this workflow was a continuation, indicates the type of continuation."
    @default :unspecified
    @type continued_initiator ::
            required ::
            :unspecified | :history_size_too_large | :too_many_history_events | :too_many_updates

    @doc "If this workflow was a continuation and that continuation failed, the details of that."
    @type continued_failure :: nested!(Failure.failure())

    @doc "If this workflow was a continuation and that continuation completed, the details of that."
    @type last_completion_result :: [nested!(Payload.payload())]

    @doc "This is the very first run id the workflow ever had, following continuation chains."
    @type first_execution_run_id :: required :: String.t()

    @doc "This workflow’s retry policy"
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "Starting at 1, the number of times we have tried to execute this workflow"
    @type attempt :: required :: integer()

    @doc "If this workflow runs on a cron schedule, it will appear here"
    @type cron_schedule :: required :: String.t()

    @doc "The absolute time at which the workflow will be timed out. This is passed without change to the next run/retry of a workflow."
    @type workflow_execution_expiration_time :: nested!(Timestamp.timestamp())

    @doc "For a cron workflow, this contains the amount of time between when this iteration of the cron workflow was scheduled and when it should run next per its cron_schedule."
    @type cron_schedule_to_schedule_interval :: nested!(Duration.duration())

    @doc "User-defined memo"
    @type memo :: nested!(Jobs.memo())

    @doc "Search attributes created/updated when this workflow was started"
    @type search_attributes :: nested!(Jobs.search_attribs())

    @doc "When the workflow execution started event was first written"
    @type start_time :: required :: nested!(Timestamp.timestamp())

    @doc """
    Contains information about the root workflow execution.
    It is possible for the namespace to be different than this workflow if using OSS and cross-namespace children, but this information is not retained. Users should take care to track it by other means in such situations.

    The root workflow execution is defined as follows:
      1. A workflow without parent workflow is its own root workflow.
      2. A workflow that has a parent workflow has the same root workflow as its parent workflow.

    See field in `WorkflowExecutionStarted` for more detail.
    """
    @type root_workflow :: nested!(Common.workflow_execution())

    @doc "Priority of this workflow execution"
    @type priority :: nested!(Priority.priority())
  end

  deftype :fire_timer do
    @structdoc "Notify a workflow that a timer has fired"

    @doc "Sequence number as provided by lang in the corresponding StartTimer command"
    @type seq :: required :: pos_integer()
  end

  deftype :update_random_seed do
    @structdoc "Workflow was reset. The randomness seed must be updated."

    @type randomness_seed :: required :: non_neg_integer()
  end

  deftype :query_workflow do
    @structdoc """
    A request to query the workflow was received.

    It is guaranteed that queries (one or more) always come in their own activation after other mutating jobs.
    """

    @doc """
    For `PollWFTResp` query field, this will be set to the special value legacy. For the queries field, the server provides a unique identifier.

    If it is a legacy query, lang cannot issue any commands in response other than to answer the query.
    """
    @type query_id :: required :: String.t()

    @doc "The query’s function/method/etc name"
    @type query_type :: required :: String.t()

    @default []
    @type arguments :: required :: [nested!(Payload.payload())]

    @doc "Headers attached to the query"
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}
  end

  deftype :cancel_workflow do
    @structdoc "A request to cancel the workflow was received."

    @type reason :: required :: String.t()
  end

  deftype :signal_workflow do
    @structdoc "A request to signal the workflow was received."

    @type signal_name :: required :: String.t()
    @type input :: required :: [nested!(Payload.payload())]

    @doc "Identity of the sender of the signal"
    @type identity :: required :: String.t()

    @doc "Headers attached to the signal"
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}
  end

  deftype :resolve_activity do
    @structdoc "An activity was resolved, result could be completed, failed or cancelled"

    @doc "Sequence number as provided by lang in the corresponding ScheduleActivity command"
    @type seq :: required :: pos_integer()
    @type result :: required :: nested!(Jobs.activity_resolution())

    @doc """
    Set to true if the resolution is for a local activity.

    This is used internally by Core and lang does not need to care about it.
    """
    @type is_local :: required :: bool()
  end

  deftype :activity_resolution do
    @structdoc "Used to report activity resolutions to lang. IE: This is what the activities are resolved with in the workflow."

    @type status ::
            nested!(Jobs.activity_completed())
            | nested!(Jobs.activity_failed())
            | nested!(Jobs.activity_cancelled())
            | nested!(Jobs.activity_backoff())
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

  deftype :activity_backoff do
    @structdoc """
    Issued when a local activity needs to retry but also wants to back off more than would be reasonable to WFT heartbeat for.

    Lang is expected to schedule a timer for the duration and then start a local activity of the same type & same inputs with the provided attempt number after the timer has elapsed.

    This exists because Core does not have a concept of starting commands by itself, they originate from lang. So expecting lang to start the timer / next pass of the activity fits more smoothly.
    """

    @doc """
    The attempt number that lang should provide when scheduling the retry.

    If the LA failed on attempt 4 and we told lang to back off with a timer, this number will be 5.
    """
    @type attempt :: required :: pos_integer()

    @type backoff_duration :: nested!(Duration.duration())

    @doc "The time the first attempt of this local activity was scheduled. Must be passed with attempt to the retry LA."
    @type original_schedule_time :: nested!(Timestamp.timestamp())
  end

  deftype :notify_has_patch do
    @structdoc """
    A patch marker has been detected and lang is being told that change exists.

    This job is strange in that it is sent pre-emptively to lang without any corresponding command being sent first.
    """

    @type patch_id :: required :: String.t()
  end

  deftype :resolve_child_workflow_execution_start do
    @structdoc "A child workflow execution has started or failed to start"

    @doc "Sequence number as provided by lang in the corresponding `start_child_workflow_execution` command"
    @type seq :: required :: pos_integer()

    @type status ::
            nested!(Jobs.child_workflow_start_succeeded())
            | nested!(Jobs.child_workflow_start_failed())
            | nested!(Jobs.child_workflow_start_cancelled())
  end

  deftype :child_workflow_start_succeeded do
    @doc "Simply pass the run_id to lang"
    @type run_id :: required :: String.t()
  end

  deftype :child_workflow_start_failed do
    @doc "Lang should have this information but it’s more convenient to pass it back for error construction on the lang side."
    @type workflow_id :: required :: String.t()
    @type workflow_type :: required :: String.t()
    @type cause :: required :: :unspecified | :workflow_already_exists
  end

  deftype :child_workflow_start_cancelled do
    @structdoc """
    `failure` should be `child_workflow_failure` with cause set to `cancelled_failure`.

    The `failure` is constructed in core for lang’s convenience.
    """
    @type failure :: nested!(Failure.failure())
  end

  deftype :resolve_child_workflow_execution do
    @structdoc "A child workflow was resolved, result could be completed or failed"

    @doc "Sequence number as provided by lang in the corresponding `start_child_workflow_execution` command"
    @type seq :: required :: pos_integer()

    @type status :: nested!(child_workflow_result)
  end

  deftype :child_workflow_result do
    @structdoc "Used by core to resolve child workflow executions."

    @type status ::
            {:completed, nested!(Payload.payload())}
            | {:failed, nested!(Failure.failure())}
            | {:cancelled, nested!(Failure.failure())}
  end

  deftype :child_workflow_completed do
    @type result :: nested!(Payload.payload())
  end

  deftype :child_workflow_failed do
    @type failure :: nested!(Failure.failure())
  end

  deftype :child_workflow_cancelled do
    @type failure :: nested!(Failure.failure())
  end

  deftype :resolve_signal_external_workflow do
    @structdoc "An attempt to signal an external workflow resolved"

    @doc "Sequence number as provided by lang in the corresponding `signal_external_workflow_execution` command"
    @type seq :: required :: pos_integer()

    @doc "If populated, this signal either failed to be sent or was cancelled depending on failure type / info."
    @type failure :: nested!(Failure.failure())
  end

  deftype :resolve_request_cancel_external_workflow do
    @structdoc "An attempt to cancel an external workflow resolved"

    @doc "Sequence number as provided by lang in the corresponding `request_cancel_external_workflow_execution` command"
    @type seq :: required :: pos_integer()

    @doc "If populated, this signal either failed to be sent or was cancelled depending on failure type / info."
    @type failure :: nested!(Failure.failure())
  end

  deftype :do_update do
    @structdoc """
    Lang is requested to invoke an update handler on the workflow.

    Lang should invoke the update validator first (if requested). If it accepts the update, immediately invoke the update handler.

    Lang must reply to the activation containing this job with an `update_response`.
    """

    @doc "A workflow-unique identifier for this update"
    @type id :: required :: String.t()

    @doc "The protocol message instance ID - this is used to uniquely track the ID server side and internally."
    @type protocol_instance_id :: required :: String.t()

    @doc "The name of the update handler"
    @type name :: required :: String.t()

    @doc "The input to the update"
    @default []
    @type input :: required :: [nested!(Payload.payload())]

    @doc "Headers attached to the update"
    @default %{}
    @type headers :: required :: %{String.t() => nested!(Payload.payload())}

    @doc "Remaining metadata associated with the update. The update_id field is stripped from here and moved to id, since it is guaranteed to be present."
    @type meta :: nested!(Jobs.update_meta())

    @doc "If set true, lang must run the update’s validator before running the handler. This will be set false during replay, since validation is not re-run during replay."
    @type run_validator :: required :: boolean()
  end

  deftype :update_meta do
    @structdoc "Metadata about a Workflow Update."

    @doc "An ID with workflow-scoped uniqueness for this Update."
    @type update_id :: required :: String.t()

    @doc "A string identifying the agent that requested this Update."
    @type identity :: required :: String.t()
  end

  deftype :resolve_nexus_operation_start do
    @structdoc "A nexus operation started."

    @doc "Sequence number as provided by lang in the corresponding `schedule_nexus_operation` command"
    @type seq :: required :: pos_integer()

    @doc """
    - `{:operation_token, String.t()}` - The operation started asynchronously. Contains a token that can be used to perform operations on the started operation by, ex, clients. A `resolve_nexus_operation` job will follow at some point.
    - `{:started_sync, boolean()}` - If true the operation “started” but only because it’s also already resolved. A `resolve_nexus_operation` job will be in the same activation.
    - `{:failed, t:Failure.failure/0}` - The operation either failed to start, was cancelled before it started, timed out, or failed synchronously. Details are included inside the message. In this case, the subsequent `resolve_nexus_operation` will never be sent.
    """
    @type status :: {:operation_token, String.t()}
  end

  deftype :resolve_nexus_operation do
    @structdoc "A nexus operation resolved."

    @doc "Sequence number as provided by lang in the corresponding `schedule_nexus_operation` command"
    @type seq :: required :: pos_integer()

    @type result :: nested!(Jobs.nexus_operation_result())
  end

  deftype :nexus_operation_result do
    @structdoc "Used by core to resolve nexus operations."

    @type status ::
            {:completed, nested!(Payload.payload())}
            | {:failed, nested!(Failure.failure())}
            | {:cancelled, nested!(Failure.failure())}
            | {:timed_out, nested!(Failure.failure())}
  end

  deftype :remove_from_cache do
    @structdoc "Remove the workflow identified by the [WorkflowActivation] containing this job from the cache after performing the activation. It is guaranteed that this will be the only job in the activation if present."

    @type reason ::
            required ::
            :unspecified
            | :cache_full
            | :cache_miss
            | :non_determinism
            | :lang_fail
            | :lang_requested
            | :task_not_found
            | :unhandled_command
            | :fatal
            | :pagination_or_history_fetch
            | :workflow_execution_ending

    @type message :: required :: String.t()
  end

  deftype :memo do
    @structdoc "A user-defined set of unindexed fields that are exposed when listing/searching workflows"

    @default %{}
    @type fields :: required :: %{String.t() => nested!(Payload.payload())}
  end

  deftype :search_attribs do
    @structdoc """
    A user-defined set of indexed fields that are used/exposed when listing/searching workflows.

    The payload is not serialized in a user-defined way.
    """
    @opts_type :: term()

    @default %{}
    @type indexed_fields :: required :: %{String.t() => nested!(Payload.payload())}

    @spec validate_opts(opts(), path :: String.t()) :: {:ok, t()} | {:error, term()}
    def validate_opts(opts, _path), do: {:ok, opts}

    @spec from_opts(opts()) :: {:ok, t()} | {:error, term()}
    def from_opts(opts), do: {:ok, search_attribs(indexed_fields: Map.new(opts, fn {key, val} -> {key, Payload.record_from_value(val)} end))}
  end
end
