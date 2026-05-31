defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.AddOrUpdateRemoteClusterRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:frontend_address, 1, type: :string, json_name: "frontendAddress")

  field(:enable_remote_cluster_connection, 2,
    type: :bool,
    json_name: "enableRemoteClusterConnection"
  )

  field(:frontend_http_address, 3, type: :string, json_name: "frontendHttpAddress")
  field(:enable_replication, 4, type: :bool, json_name: "enableReplication")
end
