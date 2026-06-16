defmodule TemporalEngineNif.Data.WorkflowCommandModifyWorkflowProperties do
  defstruct upserted_memo: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          upserted_memo: Data.WorkflowMemo.t() | nil
        }
end
