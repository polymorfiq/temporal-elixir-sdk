defmodule Temporal.CoreSdk.Data.Callback do
  defstruct [:links, variant: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          links: [Data.Link.t()],
          variant: {:nexus, Data.CallbackNexus.t()} | {:internal, Data.CallbackInternal.t()} | nil
        }
end
