defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionRequest do
  @moduledoc """
  Automatically generated module for PollNexusOperationExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`operation_id`** | `string` |  |
  | 3 | **`run_id`** | `string` | Operation run ID. If empty the request targets the latest run. |
  | 4 | **`wait_stage`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage` | Stage to wait for. The operation may be in a more advanced stage when the poll is unblocked. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :operation_id, 2, type: :string, json_name: "operationId"
  field :run_id, 3, type: :string, json_name: "runId"

  field :wait_stage, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage,
    json_name: "waitStage",
    enum: true
end
