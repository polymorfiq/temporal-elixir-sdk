defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListWorkflowExecutionsResponse do
  @moduledoc """
  Automatically generated module for ListWorkflowExecutionsResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`executions`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionInfo` |  |
  | 2 | **`next_page_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :executions, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionInfo

  field :next_page_token, 2, type: :bytes, json_name: "nextPageToken"
end
