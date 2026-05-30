defmodule Temporal.Protos.Temporal.Api.Enums.V1.PendingNexusOperationState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :PENDING_NEXUS_OPERATION_STATE_UNSPECIFIED, 0
  field :PENDING_NEXUS_OPERATION_STATE_SCHEDULED, 1
  field :PENDING_NEXUS_OPERATION_STATE_BACKING_OFF, 2
  field :PENDING_NEXUS_OPERATION_STATE_STARTED, 3
  field :PENDING_NEXUS_OPERATION_STATE_BLOCKED, 4
end
