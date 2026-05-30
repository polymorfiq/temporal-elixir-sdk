defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNamespacesResponse do
  @moduledoc """
  Automatically generated module for ListNamespacesResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespaces`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse` |  |
  | 2 | **`next_page_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespaces, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse

  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
end
