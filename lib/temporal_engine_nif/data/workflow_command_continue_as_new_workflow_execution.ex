defmodule TemporalEngineNif.Data.WorkflowCommandContinueAsNewWorkflowExecution do
  defstruct [
    :workflow_type,
    :task_queue,
    initial_versioning_behavior: :unspecified,
    versioning_intent: :unspecified,
    arguments: [],
    memo: %{},
    headers: %{},
    workflow_run_timeout: nil,
    workflow_task_timeout: nil,
    search_attributes: nil,
    retry_policy: nil
  ]

  alias TemporalEngineNif.Data

  @type versioning_intent() :: :unspecified | :compatible | :default
  @type continue_as_new_versioning_behavior() ::
          :unspecified | :auto_upgrade | :use_ramp_versioning
  @type t :: %__MODULE__{
          workflow_type: String.t(),
          task_queue: String.t(),
          arguments: [Data.Payload.t()],
          workflow_run_timeout: Data.Duration.t() | nil,
          workflow_task_timeout: Data.Duration.t() | nil,
          memo: %{String.t() => Data.Payload.t()},
          headers: %{String.t() => Data.Payload.t()},
          search_attributes: Data.WorkflowSearchAttributes.t() | nil,
          retry_policy: Data.RetryPolicy.t() | nil,
          versioning_intent: versioning_intent(),
          initial_versioning_behavior: continue_as_new_versioning_behavior()
        }
end
