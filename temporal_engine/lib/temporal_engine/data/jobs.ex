defmodule TemporalEngine.Data.Jobs do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Failure
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Data.RetryPolicy
  alias TemporalEngine.Data.Timestamp
  alias TemporalEngine.Data.Jobs

  @type job :: initialize_workflow() | fire_timer() | resolve_activity() | remove_from_cache()
  @type job_opts ::
          initialize_workflow_opts()
          | fire_timer_opts()
          | resolve_activity_opts()
          | remove_from_cache_opts()

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

    @doc "Run id of the previous workflow which continued-as-new or retired or cron executed into this workflow, if any."
    @type continued_from_execution_run_id :: required :: String.t()

    @doc "If this workflow was a continuation, indicates the type of continuation."
    @default :unspecified
    @type continued_initiator :: required :: nested!(Jobs.continued_as_new_initiator())

    @doc "If this workflow was a continuation and that continuation failed, the details of that."
    @type continued_failure :: nested!(Failure.failure())

    @doc "If this workflow was a continuation and that continuation completed, the details of that."
    @type last_completion_result :: [nested!(Payload.payload())]

    @doc "This is the very first run id the workflow ever had, following continuation chains."
    @type first_execution_run_id :: required :: String.t()

    @doc "This workflow’s retry policy"
    @type retry_policy :: nested!(RetryPolicy.policy())

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
    @type start_time :: nested!(Timestamp.timestamp())

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

  deftype :query_workflow do
    @structdoc "Query a workflow"

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

  deftype :resolve_activity do
    @structdoc "Notify a workflow that an activity has been resolved"

    @doc "Sequence number as provided by lang in the corresponding ScheduleActivity command"
    @type seq :: required :: pos_integer()
    @type result :: required :: nested!(Jobs.activity_status())

    @doc """
    Set to true if the resolution is for a local activity.

    This is used internally by Core and lang does not need to care about it.
    """
    @type is_local :: required :: bool()
  end

  deftype :remove_from_cache do
    @type reason :: required :: nested!(Jobs.cache_eviction_reason())
    @type message :: required :: String.t()
  end

  @type continued_as_new_initiator :: :unspecified | :workflow | :retry | :cron_schedule
  @type continued_as_new_initiator_opts :: continued_as_new_initiator()

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

    @default %{}
    @type indexed_fields :: required :: %{String.t() => nested!(Payload.payload())}
  end

  @type activity_status ::
          activity_completed() | activity_failed() | activity_cancelled() | activity_backoff()
  @type activity_status_opts :: activity_status()

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

  @type cache_eviction_reason ::
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

  @type cache_eviction_reason_opts :: cache_eviction_reason()
end
