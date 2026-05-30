defmodule Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationIdReusePolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :NEXUS_OPERATION_ID_REUSE_POLICY_UNSPECIFIED, 0
  field :NEXUS_OPERATION_ID_REUSE_POLICY_ALLOW_DUPLICATE, 1
  field :NEXUS_OPERATION_ID_REUSE_POLICY_ALLOW_DUPLICATE_FAILED_ONLY, 2
  field :NEXUS_OPERATION_ID_REUSE_POLICY_REJECT_DUPLICATE, 3
end
