defmodule Temporal.CoreSdk.Data.WorkflowDefinition do
  defstruct [
    :name
  ]

  @type t :: %__MODULE__{
          name: String.t()
        }
end
