defmodule TemporalEngineNif.Data.NexusStartOperationRequest do
  defstruct [:service, :operation, :request_id, :callback, :callback_header, :links, payload: nil]

  alias TemporalEngineNif.Data

  @type t :: %__MODULE__{
          service: String.t(),
          operation: String.t(),
          request_id: String.t(),
          callback: String.t(),
          payload: Data.Payload.t() | nil,
          callback_header: map(),
          links: [Data.NexusLink.t()]
        }
end
