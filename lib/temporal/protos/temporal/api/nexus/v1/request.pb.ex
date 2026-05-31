defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Request do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:header, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.Request.HeaderEntry,
    map: true
  )

  field(:scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")
  field(:capabilities, 100, type: Temporal.Protos.Temporal.Api.Nexus.V1.Request.Capabilities)

  field(:start_operation, 3,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest,
    json_name: "startOperation",
    oneof: 0
  )

  field(:cancel_operation, 4,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.CancelOperationRequest,
    json_name: "cancelOperation",
    oneof: 0
  )

  field(:endpoint, 10, type: :string)
end
