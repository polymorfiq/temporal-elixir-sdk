defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNamespacesResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespaces, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse
  )

  field(:next_page_token, 2, type: :bytes, json_name: "nextPageToken")
end
