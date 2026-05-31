defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListClustersResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:clusters, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Operatorservice.V1.ClusterMetadata
  )

  field(:next_page_token, 4, type: :bytes, json_name: "nextPageToken")
end
