defmodule Temporal.CoreSdk.Data.ActivationUpdateRandomSeed do
  defstruct [:randomness_seed]

  @type t :: %__MODULE__{
          randomness_seed: pos_integer()
        }
end
