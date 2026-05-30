defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowRulesResponse do
  @moduledoc """
  Automatically generated module for ListWorkflowRulesResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`next_page_token`** | `bytes` |  |
  | 1 | **`rules`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rules, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule
  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
end
