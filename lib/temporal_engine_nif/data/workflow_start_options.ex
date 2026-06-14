defmodule TemporalEngineNif.Data.WorkflowStartOptions do
  defstruct [
    :task_queue,
    :workflow_id,
    id_reuse_policy: :unspecified,
    id_conflict_policy: :unspecified,
    enable_eager_workflow_start: false,
    priority: [priority_key: 0, fairness_key: "", fairness_weight: 1.0],
    links: [],
    completion_callbacks: [],
    execution_timeout: nil,
    run_timeout: nil,
    task_timeout: nil,
    cron_schedule: nil,
    search_attributes: nil,
    retry_policy: nil,
    start_signal: nil,
    header: nil,
    static_summary: nil,
    static_details: nil
  ]

  alias TemporalEngineNif.Data
  alias Temporal.Comms.Payload
  alias Temporal.Comms.Shared.Duration
  alias Temporal.Comms.Shared.Priority
  alias Temporal.Comms.Shared.RetryPolicy

  @type id_conflict_policy :: :unspecified | :fail | :use_existing | :terminate_existing
  @type id_reuse_policy ::
          :unspecified
          | :allow_duplicate
          | :allow_duplicate_failed_only
          | :reject_duplicate
          | :terminate_if_running

  @type t :: %__MODULE__{
          task_queue: String.t(),
          workflow_id: String.t(),
          id_reuse_policy: id_reuse_policy(),
          id_conflict_policy: id_conflict_policy(),
          execution_timeout: Duration.t() | nil,
          run_timeout: Duration.t() | nil,
          task_timeout: Duration.t() | nil,
          cron_schedule: String.t() | nil,
          search_attributes: %{String.t() => Payload.t()} | nil,
          enable_eager_workflow_start: bool(),
          retry_policy: RetryPolicy.t() | nil,
          start_signal: Data.WorkflowStartSignal.t() | nil,
          links: [Data.Link.t()],
          completion_callbacks: [Data.Callback.t()],
          priority: Priority.t(),
          header: Data.Header.t() | nil,
          static_summary: String.t() | nil,
          static_details: String.t() | nil
        }
end
