defmodule Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:namespace_id, 6, type: :string, json_name: "namespaceId")
  field(:initiated_event_id, 2, type: :int64, json_name: "initiatedEventId")

  field(:workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:header, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
end
