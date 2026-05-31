defmodule Temporal.Protos.Temporal.Api.Failure.V1.TimeoutFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:timeout_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TimeoutType,
    json_name: "timeoutType",
    enum: true
  )

  field(:last_heartbeat_details, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastHeartbeatDetails"
  )
end
