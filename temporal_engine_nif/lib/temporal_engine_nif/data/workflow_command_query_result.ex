defmodule TemporalEngineNif.Data.WorkflowCommandQueryResult do
  defstruct [:query_id, variant: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          query_id: String.t(),
          variant: Data.WorkflowCommandQueryResultVariant.t() | nil
        }
end
