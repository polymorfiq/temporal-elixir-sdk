defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Request do
  @moduledoc """
  A Nexus request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`cancel_operation`** | `Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationRequest` |  |
  | 100 | **`capabilities`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Request.Capabilities` |  |
  | 10 | **`endpoint`** | `string` | The endpoint this request was addressed to before forwarding to the worker. |
  | 1 | **`header`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Request.HeaderEntry` | Headers extracted from the original request in the Temporal frontend. |
  | 2 | **`scheduled_time`** | `Google.Protobuf.Timestamp` | The timestamp when the request was scheduled in the frontend. |
  | 3 | **`start_operation`** | `Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest` |  |

  ### Additional Notes

    * `endpoint` (`string`): The endpoint this request was addressed to before forwarding to the worker.
      Supported from server version 1.30.0.
    * `header` (`Temporal.Protos.Temporal.Api.Nexus.V1.Request.HeaderEntry`): Headers extracted from the original request in the Temporal frontend.
      When using Nexus over HTTP, this includes the request's HTTP headers ignoring multiple values.
    * `scheduled_time` (`Google.Protobuf.Timestamp`): The timestamp when the request was scheduled in the frontend.
      (-- api-linter: core::0142::time-field-names=disabled
          aip.dev/not-precedent: Not following linter rules. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :header, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.Request.HeaderEntry,
    map: true

  field :scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"
  field :capabilities, 100, type: Temporal.Protos.Temporal.Api.Nexus.V1.Request.Capabilities

  field :start_operation, 3,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest,
    json_name: "startOperation",
    oneof: 0

  field :cancel_operation, 4,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationRequest,
    json_name: "cancelOperation",
    oneof: 0

  field :endpoint, 10, type: :string
end
