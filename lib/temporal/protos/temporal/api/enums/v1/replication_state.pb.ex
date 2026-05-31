defmodule Temporal.Protos.Temporal.Api.Enums.V1.ReplicationState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:REPLICATION_STATE_UNSPECIFIED, 0)
  field(:REPLICATION_STATE_NORMAL, 1)
  field(:REPLICATION_STATE_HANDOVER, 2)
end
