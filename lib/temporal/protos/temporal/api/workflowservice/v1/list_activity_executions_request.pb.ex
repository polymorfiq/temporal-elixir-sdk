defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListActivityExecutionsRequest do
  @moduledoc """
  Automatically generated module for ListActivityExecutionsRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`next_page_token`** | `bytes` | Token returned in ListActivityExecutionsResponse. |
  | 2 | **`page_size`** | `int32` | Max number of executions to return per page. |
  | 4 | **`query`** | `string` | Visibility query, see https://docs.temporal.io/list-filter for the syntax. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :page_size, 2, type: :int32, json_name: "pageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :query, 4, type: :string
end
