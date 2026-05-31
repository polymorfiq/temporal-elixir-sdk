defmodule Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationIdConflictPolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:NEXUS_OPERATION_ID_CONFLICT_POLICY_UNSPECIFIED, 0)
  field(:NEXUS_OPERATION_ID_CONFLICT_POLICY_FAIL, 1)
  field(:NEXUS_OPERATION_ID_CONFLICT_POLICY_USE_EXISTING, 2)
end
