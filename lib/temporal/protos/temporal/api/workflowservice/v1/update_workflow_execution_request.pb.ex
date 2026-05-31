defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:first_execution_run_id, 3, type: :string, json_name: "firstExecutionRunId")

  field(:wait_policy, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy,
    json_name: "waitPolicy"
  )

  field(:request, 5, type: Temporal.Protos.Temporal.Api.Update.V1.Request)
end
