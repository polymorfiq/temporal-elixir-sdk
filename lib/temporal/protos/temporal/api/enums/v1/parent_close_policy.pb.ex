defmodule Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:PARENT_CLOSE_POLICY_UNSPECIFIED, 0)
  field(:PARENT_CLOSE_POLICY_TERMINATE, 1)
  field(:PARENT_CLOSE_POLICY_ABANDON, 2)
  field(:PARENT_CLOSE_POLICY_REQUEST_CANCEL, 3)
end
