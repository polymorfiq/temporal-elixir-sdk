defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListNexusEndpointsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:next_page_token, 1, type: :bytes, json_name: "nextPageToken")
  field(:endpoints, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Endpoint)
end
