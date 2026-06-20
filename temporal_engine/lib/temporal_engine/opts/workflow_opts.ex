defmodule TemporalEngine.Opts.WorkflowOpts do
  use TemporalEngine.Data.TypeSpec

  require TemporalEngine.Data.Common

  alias TemporalEngine.Data.Common
  alias TemporalEngine.Data.Duration
  alias TemporalEngine.Data.Payload
  alias TemporalEngine.Data.Priority
  alias TemporalEngine.Opts.WorkflowOpts

  deftype :workflow_definition do
    @type name :: required :: String.t()
  end

  deftype :workflow_start_opts do
    @doc "The task queue to run the workflow on."
    @type task_queue :: required :: String.t()

    @doc "The workflow ID."
    @type workflow_id :: required :: String.t()

    @doc """
    Defines whether to allow re-using a workflow id from a previously closed workflow. If the request is denied, the server returns a WorkflowExecutionAlreadyStartedFailure error.

    See `id_conflict_policy` for handling workflow id duplication with a running workflow.
    """
    @default :unspecified
    @type id_reuse_policy ::
            required ::
            :unspecified
            | :allow_duplicate
            | :allow_duplicate_failed_only
            | :reject_duplicate
            | :terminate_if_running

    @doc """
    Defines what to do when trying to start a workflow with the same workflow id as a running workflow.

    Note that it is never valid to have two actively running instances of the same workflow id.

    See `id_reuse_policy` for handling workflow id duplication with a closed workflow.
    """
    @default :unspecified
    @type id_conflict_policy :: :unspecified | :fail | :use_existing | :terminate_existing

    @doc "Optionally set the execution timeout for the workflow https://docs.temporal.io/workflows/#workflow-execution-timeout"
    @type execution_timeout :: nested!(Duration.duration())

    @doc "Optionally indicates the default run timeout for a workflow run"
    @type run_timeout :: nested!(Duration.duration())

    @doc "Optionally indicates the default task timeout for a workflow run"
    @type task_timeout :: nested!(Duration.duration())

    @doc "Optionally set a cron schedule for the workflow"
    @type cron_schedule :: String.t()

    @doc "Optionally associate extra search attributes with a workflow"
    @type search_attributes :: %{String.t() => nested!(Payload.payload())}

    @doc """
    Optionally enable Eager Workflow Start, a latency optimization using local workers

    NOTE: Experimental
    """
    @default false
    @type enable_eager_workflow_start :: boolean()

    @doc "Optionally set a retry policy for the workflow"
    @type retry_policy :: nested!(Common.retry_policy())

    @doc "If set, send a signal to the workflow atomically with start. The workflow will receive this signal before its first task."
    @type start_signal :: nested!(WorkflowOpts.workflow_start_signal())

    @doc "Links to associate with the workflow. Ex: References to a nexus operation."
    @default []
    @type links :: required :: [nested!(Common.link())]

    @doc "Callbacks that will be invoked upon workflow completion. For, ex, completing nexus operations."
    @default []
    @type completion_callbacks :: required :: [nested!(Common.callback())]

    @doc "Priority for the workflow. Defaults to all-inherited (empty)."
    @type priority :: nested!(Priority.priority())

    @doc "Headers to include with the start request."
    @type header :: nested!(Common.header())

    @doc "Single-line static summary for the workflow, shown in the Temporal UI."
    @type static_summary :: String.t()

    @doc "Multi-line static details for the workflow, shown in the Temporal UI."
    @type static_details :: String.t()
  end

  deftype :workflow_start_signal do
    @structdoc "A signal to send atomically when starting a workflow. Use with `workflow_start_opts::start_signal` to achieve signal-with-start behavior."

    @doc "Name of the signal to send."
    @type signal_name :: required :: String.t()

    @doc "Payload for the signal."
    @type input :: [nested!(Payload.payload())]

    @doc "Headers for the signal."
    @type header :: nested!(Common.header())
  end
end
