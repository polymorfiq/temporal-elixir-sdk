defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListClustersResponse do
  @moduledoc """
  Automatically generated module for ListClustersResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`clusters`** | `Temporal.Protos.Temporal.Api.Operatorservice.V1.ClusterMetadata` | List of all cluster information |
  | 4 | **`next_page_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :clusters, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Operatorservice.V1.ClusterMetadata

  field :next_page_token, 4, type: :bytes, json_name: "nextPageToken"
end
