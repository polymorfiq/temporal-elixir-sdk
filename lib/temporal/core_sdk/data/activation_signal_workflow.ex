defmodule Temporal.CoreSdk.Data.ActivationSignalWorkflow do
  defstruct [:signal_name, :input, :identity, :headers]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          signal_name: String.t(),
          input: [Data.Payload.t()],
          identity: String.t(),
          headers: map()
        }
end
