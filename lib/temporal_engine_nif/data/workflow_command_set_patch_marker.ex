defmodule TemporalEngineNif.Data.WorkflowCommandSetPatchMarker do
  defstruct [:patch_id, :deprecated]

  @type t :: %__MODULE__{
          patch_id: String.t(),
          deprecated: bool()
        }
end
