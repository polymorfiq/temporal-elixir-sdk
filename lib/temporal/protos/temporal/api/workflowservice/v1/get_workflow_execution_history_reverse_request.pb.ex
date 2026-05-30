defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkflowExecutionHistoryReverseRequest do
  @moduledoc """
  Automatically generated module for GetWorkflowExecutionHistoryReverseRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 3 | **`maximum_page_size`** | `int32` |  |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`next_page_token`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :maximum_page_size, 3, type: :int32, json_name: "maximumPageSize"
  field :next_page_token, 4, type: :bytes, json_name: "nextPageToken"
end
