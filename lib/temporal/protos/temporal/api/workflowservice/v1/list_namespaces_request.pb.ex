defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListNamespacesRequest do
  @moduledoc """
  Automatically generated module for ListNamespacesRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`namespace_filter`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceFilter` |  |
  | 2 | **`next_page_token`** | `bytes` |  |
  | 1 | **`page_size`** | `int32` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :page_size, 1, type: :int32, json_name: "pageSize"
  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"

  field :namespace_filter, 3,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceFilter,
    json_name: "namespaceFilter"
end
