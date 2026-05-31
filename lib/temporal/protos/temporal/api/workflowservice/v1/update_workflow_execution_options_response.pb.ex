defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionOptionsResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_execution_options, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionOptions,
    json_name: "workflowExecutionOptions"
  )
end
