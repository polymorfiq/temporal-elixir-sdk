defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse.QueriesEntry do
  @moduledoc """
  Automatically generated module for QueriesEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | A unique identifier for this task |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery
end
