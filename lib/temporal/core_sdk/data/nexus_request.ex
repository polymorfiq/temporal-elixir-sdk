defmodule Temporal.CoreSdk.Data.NexusRequest do
  defstruct [:header, :endpoint, scheduled_time: nil, capabilities: nil, variant: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          header: map(),
          scheduled_time: Data.Timestamp.t() | nil,
          capabilities: Data.NexusCapabilities.t() | nil,
          endpoint: String.t(),
          variant: Data.NexusRequestVariant.t() | nil
        }
end
