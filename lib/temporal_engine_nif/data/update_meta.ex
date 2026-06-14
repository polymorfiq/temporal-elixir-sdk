defmodule TemporalEngineNif.Data.UpdateMeta do
  defstruct [:update_id, :identity]

  @type t :: %__MODULE__{
          update_id: String.t(),
          identity: String.t()
        }
end
