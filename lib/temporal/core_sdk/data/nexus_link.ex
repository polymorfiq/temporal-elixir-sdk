defmodule Temporal.CoreSdk.Data.NexusLink do
  defstruct [:url, :link_type]

  @type t :: %__MODULE__{
          url: String.t(),
          link_type: String.t()
        }
end
