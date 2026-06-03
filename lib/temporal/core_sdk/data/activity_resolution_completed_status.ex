defmodule Temporal.CoreSdk.Data.ActivityResolutionCompletedStatus do
  defstruct result: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          result: Data.ActivationPayload.t() | nil
        }
end
