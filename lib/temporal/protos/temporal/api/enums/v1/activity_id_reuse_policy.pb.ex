defmodule Temporal.Protos.Temporal.Api.Enums.V1.ActivityIdReusePolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:ACTIVITY_ID_REUSE_POLICY_UNSPECIFIED, 0)
  field(:ACTIVITY_ID_REUSE_POLICY_ALLOW_DUPLICATE, 1)
  field(:ACTIVITY_ID_REUSE_POLICY_ALLOW_DUPLICATE_FAILED_ONLY, 2)
  field(:ACTIVITY_ID_REUSE_POLICY_REJECT_DUPLICATE, 3)
end
