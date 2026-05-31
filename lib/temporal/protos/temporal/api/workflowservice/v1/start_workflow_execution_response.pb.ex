defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:run_id, 1, type: :string, json_name: "runId")
  field(:started, 3, type: :bool)

  field(:status, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true
  )

  field(:eager_workflow_task, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse,
    json_name: "eagerWorkflowTask"
  )

  field(:link, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
