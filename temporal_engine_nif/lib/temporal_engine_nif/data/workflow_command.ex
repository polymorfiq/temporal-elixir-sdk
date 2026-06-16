defmodule TemporalEngineNif.Data.WorkflowCommand do
  defstruct user_metadata: nil,
            variant: nil

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          user_metadata: Data.UserMetadata.t() | nil,
          variant: Data.WorkflowCommandVariant.t() | nil
        }
end
