defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNamespaceRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:namespace_id, 2, type: :string, json_name: "namespaceId")

  field(:namespace_delete_delay, 3,
    type: Google.Protobuf.Duration,
    json_name: "namespaceDeleteDelay"
  )
end
