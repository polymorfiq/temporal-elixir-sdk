defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListDeploymentsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:page_size, 2, type: :int32, json_name: "pageSize")
  field(:next_page_token, 3, type: :bytes, json_name: "nextPageToken")
  field(:series_name, 4, type: :string, json_name: "seriesName")
end
