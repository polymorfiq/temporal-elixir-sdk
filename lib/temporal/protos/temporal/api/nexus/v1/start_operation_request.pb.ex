defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest do
  @moduledoc """
  A request to start an operation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`callback`** | `string` | Callback URL to call upon completion if the started operation is async. |
  | 6 | **`callback_header`** | `Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest.CallbackHeaderEntry` | Header that is expected to be attached to the callback request when the operation completes. |
  | 7 | **`links`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Link` | Links contain caller information and can be attached to the operations started by the handler. |
  | 2 | **`operation`** | `string` | Type of operation to start. |
  | 5 | **`payload`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Full request body from the incoming HTTP request. |
  | 3 | **`request_id`** | `string` | A request ID that can be used as an idempotentency key. |
  | 1 | **`service`** | `string` | Name of service to start the operation in. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :service, 1, type: :string
  field :operation, 2, type: :string
  field :request_id, 3, type: :string, json_name: "requestId"
  field :callback, 4, type: :string
  field :payload, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payload

  field :callback_header, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest.CallbackHeaderEntry,
    json_name: "callbackHeader",
    map: true

  field :links, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Link
end
