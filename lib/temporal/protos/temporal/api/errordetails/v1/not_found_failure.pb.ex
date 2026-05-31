defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NotFoundFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current_cluster, 1, type: :string, json_name: "currentCluster")
  field(:active_cluster, 2, type: :string, json_name: "activeCluster")
end
