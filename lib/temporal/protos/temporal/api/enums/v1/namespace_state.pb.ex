defmodule Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :NAMESPACE_STATE_UNSPECIFIED, 0
  field :NAMESPACE_STATE_REGISTERED, 1
  field :NAMESPACE_STATE_DEPRECATED, 2
  field :NAMESPACE_STATE_DELETED, 3
end
