defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:operation, 0)

  field(:start_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionRequest,
    json_name: "startWorkflow",
    oneof: 0
  )

  field(:update_workflow, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest,
    json_name: "updateWorkflow",
    oneof: 0
  )
end
