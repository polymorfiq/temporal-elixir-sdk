defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:signal_name, 3, type: :string, json_name: "signalName")
  field(:input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 5, type: :string)
  field(:request_id, 6, type: :string, json_name: "requestId")
  field(:control, 7, type: :string, deprecated: true)
  field(:header, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:links, 10, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
