defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.QueryResultsEntry do
  @moduledoc """
  Automatically generated module for QueryResultsEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | The task token as received in `PollWorkflowTaskQueueResponse` |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Query.V1.WorkflowQueryResult` | A list of commands generated when driving the workflow code in response to the new task |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQueryResult
end
