defmodule Temporal.Protos.Temporal.Api.History.V1.ExternalWorkflowExecutionSignaledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:initiated_event_id, 1, type: :int64, json_name: "initiatedEventId")
  field(:namespace, 2, type: :string)
  field(:namespace_id, 5, type: :string, json_name: "namespaceId")

  field(:workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:control, 4, type: :string, deprecated: true)
end
