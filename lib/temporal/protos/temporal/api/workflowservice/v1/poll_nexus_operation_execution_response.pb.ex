defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionResponse do
  @moduledoc """
  Automatically generated module for PollNexusOperationExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The failure if the operation completed unsuccessfully. |
  | 3 | **`operation_token`** | `string` | Operation token. Only populated for asynchronous operations after a successful StartOperation call. |
  | 4 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | The result if the operation completed successfully. |
  | 1 | **`run_id`** | `string` | The run ID of the operation, useful when run_id was not specified in the request. |
  | 2 | **`wait_stage`** | `Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage` | The current stage of the operation. May be more advanced than the stage requested in the poll. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :outcome, 0

  field :run_id, 1, type: :string, json_name: "runId"

  field :wait_stage, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage,
    json_name: "waitStage",
    enum: true

  field :operation_token, 3, type: :string, json_name: "operationToken"
  field :result, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload, oneof: 0
  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0
end
