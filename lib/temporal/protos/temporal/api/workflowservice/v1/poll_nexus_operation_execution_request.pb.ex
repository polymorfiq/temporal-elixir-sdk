defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusOperationExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:operation_id, 2, type: :string, json_name: "operationId")
  field(:run_id, 3, type: :string, json_name: "runId")

  field(:wait_stage, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationWaitStage,
    json_name: "waitStage",
    enum: true
  )
end
