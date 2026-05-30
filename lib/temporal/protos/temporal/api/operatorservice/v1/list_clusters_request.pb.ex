defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ListClustersRequest do
  @moduledoc """
  Automatically generated module for ListClustersRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`next_page_token`** | `bytes` |  |
  | 1 | **`page_size`** | `int32` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :page_size, 1, type: :int32, json_name: "pageSize"
  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
end
