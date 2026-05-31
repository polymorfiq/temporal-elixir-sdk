defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:outcome, 0)

  field(:run_id, 1, type: :string, json_name: "runId")

  field(:wait_stage, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage,
    json_name: "waitStage",
    enum: true
  )

  field(:operation_token, 3, type: :string, json_name: "operationToken")
  field(:result, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload, oneof: 0)
  field(:failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0)
end
