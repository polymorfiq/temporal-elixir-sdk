defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceFilter do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:include_deleted, 1, type: :bool, json_name: "includeDeleted")
end
