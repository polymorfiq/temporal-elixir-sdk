defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveRemoteClusterRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cluster_name, 1, type: :string, json_name: "clusterName")
end
