defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionSignaledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:signal_name, 1, type: :string, json_name: "signalName")
  field(:input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 3, type: :string)
  field(:header, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:skip_generate_workflow_task, 5,
    type: :bool,
    json_name: "skipGenerateWorkflowTask",
    deprecated: true
  )

  field(:external_workflow_execution, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "externalWorkflowExecution"
  )

  field(:request_id, 7, type: :string, json_name: "requestId")
end
