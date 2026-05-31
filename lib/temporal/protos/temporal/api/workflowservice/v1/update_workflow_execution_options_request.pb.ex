defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionOptionsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_execution_options, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"
  )

  field(:update_mask, 4, type: Google.Protobuf.FieldMask, json_name: "updateMask")
  field(:identity, 5, type: :string)
end
