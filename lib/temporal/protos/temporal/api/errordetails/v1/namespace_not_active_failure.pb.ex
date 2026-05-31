defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NamespaceNotActiveFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:current_cluster, 2, type: :string, json_name: "currentCluster")
  field(:active_cluster, 3, type: :string, json_name: "activeCluster")
end
