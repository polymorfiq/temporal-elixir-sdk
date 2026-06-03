defmodule Temporal.CoreSdk.Data.WorkflowCommandModifyWorkflowProperties do
  defstruct upserted_memo: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          upserted_memo: Data.WorkflowMemo.t() | nil
        }
end
