defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Response do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:start_operation, 1,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse,
    json_name: "startOperation",
    oneof: 0
  )

  field(:cancel_operation, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationResponse,
    json_name: "cancelOperation",
    oneof: 0
  )
end
