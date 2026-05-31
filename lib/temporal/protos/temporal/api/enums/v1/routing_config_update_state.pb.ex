defmodule Temporal.Protos.Temporal.Api.Enums.V1.RoutingConfigUpdateState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:ROUTING_CONFIG_UPDATE_STATE_UNSPECIFIED, 0)
  field(:ROUTING_CONFIG_UPDATE_STATE_IN_PROGRESS, 1)
  field(:ROUTING_CONFIG_UPDATE_STATE_COMPLETED, 2)
end
