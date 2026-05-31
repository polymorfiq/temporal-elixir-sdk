defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowRulesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:next_page_token, 2, type: :bytes, json_name: "nextPageToken")
end
