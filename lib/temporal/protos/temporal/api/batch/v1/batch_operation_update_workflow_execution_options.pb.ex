defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateWorkflowExecutionOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:identity, 1, type: :string)

  field(:workflow_execution_options, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"
  )

  field(:update_mask, 3, type: Google.Protobuf.FieldMask, json_name: "updateMask")
end
