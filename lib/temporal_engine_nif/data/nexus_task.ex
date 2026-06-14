defmodule TemporalEngineNif.Data.NexusTask do
  defstruct [
    :request_deadline,
    :endpoint,
    :variant
  ]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          request_deadline: Data.Timestamp.t() | nil,
          endpoint: String.t(),
          variant: Data.NexusTaskVariant.t() | nil
        }
end
