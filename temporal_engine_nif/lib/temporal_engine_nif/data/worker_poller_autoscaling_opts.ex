defmodule TemporalEngineNif.Data.WorkerPollerAutoscalingOpts do
  defstruct [:minimum, :maximum, :initial]

  @type t :: %__MODULE__{
          minimum: pos_integer(),
          maximum: pos_integer(),
          initial: pos_integer()
        }
end
