defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Response do
  @moduledoc """
  A response indicating that the handler has successfully processed a request.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`cancel_operation`** | `Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationResponse` |  |
  | 1 | **`start_operation`** | `Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :start_operation, 1,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse,
    json_name: "startOperation",
    oneof: 0

  field :cancel_operation, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationResponse,
    json_name: "cancelOperation",
    oneof: 0
end
