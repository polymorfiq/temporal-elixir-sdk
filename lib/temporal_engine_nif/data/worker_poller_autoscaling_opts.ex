defmodule TemporalEngineNif.Data.WorkerPollerAutoscalingOpts do
  defstruct [:minimum, :maximum, :initial]

  @type t :: %__MODULE__{
          minimum: pos_integer(),
          maximum: pos_integer(),
          initial: pos_integer()
        }

  @type opts :: [
          {:minimum, pos_integer()} | {:maximum, pos_integer()} | {:initial, pos_integer()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    struct!(__MODULE__, opts)
  end
end
