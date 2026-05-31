defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryReverseResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:history, 1, type: Temporal.Protos.Temporal.Api.History.V1.History)
  field(:next_page_token, 3, type: :bytes, json_name: "nextPageToken")
end
