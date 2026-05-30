defmodule Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :RESET_REAPPLY_EXCLUDE_TYPE_UNSPECIFIED, 0
  field :RESET_REAPPLY_EXCLUDE_TYPE_SIGNAL, 1
  field :RESET_REAPPLY_EXCLUDE_TYPE_UPDATE, 2
  field :RESET_REAPPLY_EXCLUDE_TYPE_NEXUS, 3
  field :RESET_REAPPLY_EXCLUDE_TYPE_CANCEL_REQUEST, 4
end
