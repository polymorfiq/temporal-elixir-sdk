defmodule TemporalEngineNif.Data.WorkflowCommandSetPatchMarker do
  defstruct [:patch_id, :deprecated]

  @type t :: %__MODULE__{
          patch_id: String.t(),
          deprecated: bool()
        }

  @type opts :: [{:patch_id, String.t()} | {:deprecated, bool()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts), do: struct!(__MODULE__, opts)
end
