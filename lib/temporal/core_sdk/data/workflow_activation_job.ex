defmodule Temporal.CoreSdk.Data.WorkflowActivationJob do
  defstruct variant: nil

  alias Temporal.CoreSdk.Data.WorkflowActivationJobVariant

  @type t :: %__MODULE__{
          variant: WorkflowActivationJobVariant.t() | nil
        }
end
