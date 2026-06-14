defmodule TemporalEngineNif.Data.WorkerPollerSimpleMaximumOpts do
  defstruct [:simple_maximum]

  @type t :: %__MODULE__{
          simple_maximum: pos_integer()
        }

  @type opts :: [{:simple_maximum, pos_integer()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
