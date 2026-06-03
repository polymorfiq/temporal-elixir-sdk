defmodule Temporal.CoreSdk.Data.WorkflowCommandQueryResult do
  defstruct [:query_id, variant: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          query_id: String.t(),
          variant: Data.WorkflowCommandQueryResultVariant.t() | nil
        }
end
