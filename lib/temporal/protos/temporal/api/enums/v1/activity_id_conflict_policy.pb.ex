defmodule Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdConflictPolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :ACTIVITY_ID_CONFLICT_POLICY_UNSPECIFIED, 0
  field :ACTIVITY_ID_CONFLICT_POLICY_FAIL, 1
  field :ACTIVITY_ID_CONFLICT_POLICY_USE_EXISTING, 2
end
