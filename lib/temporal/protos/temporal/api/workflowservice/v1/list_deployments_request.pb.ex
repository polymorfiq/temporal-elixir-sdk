defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsRequest do
  @moduledoc """
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`next_page_token`** | `bytes` |  |
  | 2 | **`page_size`** | `int32` |  |
  | 4 | **`series_name`** | `string` | Optional. Use to filter based on exact series name match. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :page_size, 2, type: :int32, json_name: "pageSize"
  field :next_page_token, 3, type: :bytes, json_name: "nextPageToken"
  field :series_name, 4, type: :string, json_name: "seriesName"
end
