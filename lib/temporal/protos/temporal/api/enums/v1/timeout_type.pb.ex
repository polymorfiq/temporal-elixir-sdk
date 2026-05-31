defmodule Temporal.Protos.Temporal.Api.Enums.V1.TimeoutType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:TIMEOUT_TYPE_UNSPECIFIED, 0)
  field(:TIMEOUT_TYPE_START_TO_CLOSE, 1)
  field(:TIMEOUT_TYPE_SCHEDULE_TO_START, 2)
  field(:TIMEOUT_TYPE_SCHEDULE_TO_CLOSE, 3)
  field(:TIMEOUT_TYPE_HEARTBEAT, 4)
end
