defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:reason, 3, type: :string)
  field(:details, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 5, type: :string)
  field(:first_execution_run_id, 6, type: :string, json_name: "firstExecutionRunId")
  field(:links, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
