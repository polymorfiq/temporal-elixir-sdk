defmodule Temporal.CoreSdk.Data.WorkflowCommandUpsertWorkflowSearchAttributes do
  defstruct search_attributes: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          search_attributes: Data.WorkflowSearchAttributes.t() | nil
        }
end
