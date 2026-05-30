defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListSchedulesRequest do
  @moduledoc """
  Automatically generated module for ListSchedulesRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`maximum_page_size`** | `int32` | How many to return at once. |
  | 1 | **`namespace`** | `string` | The namespace to list schedules in. |
  | 3 | **`next_page_token`** | `bytes` | Token to get the next page of results. |
  | 4 | **`query`** | `string` | Query to filter schedules. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :maximum_page_size, 2, type: :int32, json_name: "maximumPageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :query, 4, type: :string
end
