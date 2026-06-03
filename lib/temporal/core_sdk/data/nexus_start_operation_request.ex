defmodule Temporal.CoreSdk.Data.NexusStartOperationRequest do
  defstruct [:service, :operation, :request_id, :callback, :callback_header, :links, payload: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          service: String.t(),
          operation: String.t(),
          request_id: String.t(),
          callback: String.t(),
          payload: Data.ActivationPayload.t() | nil,
          callback_header: map(),
          links: [Data.NexusLink.t()]
        }
end
