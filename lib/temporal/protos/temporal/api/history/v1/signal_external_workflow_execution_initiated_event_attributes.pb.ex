defmodule Temporal.Protos.Temporal.Api.History.V1.SignalExternalWorkflowExecutionInitiatedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:namespace, 2, type: :string)
  field(:namespace_id, 9, type: :string, json_name: "namespaceId")

  field(:workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:signal_name, 4, type: :string, json_name: "signalName")
  field(:input, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:control, 6, type: :string, deprecated: true)
  field(:child_workflow_only, 7, type: :bool, json_name: "childWorkflowOnly")
  field(:header, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
end
