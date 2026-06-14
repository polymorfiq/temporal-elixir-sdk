defmodule TemporalEngineNif.Data.WorkflowCommandUpsertWorkflowSearchAttributes do
  defstruct search_attributes: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          search_attributes: Data.WorkflowSearchAttributes.t() | nil
        }
end
