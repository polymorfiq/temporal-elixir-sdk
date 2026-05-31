defmodule Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:namespace_id, 8, type: :string, json_name: "namespaceId")
  field(:workflow_id, 2, type: :string, json_name: "workflowId")

  field(:workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:cause, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.StartChildWorkflowExecutionFailedCause,
    enum: true
  )

  field(:control, 5, type: :string, deprecated: true)
  field(:initiated_event_id, 6, type: :int64, json_name: "initiatedEventId")

  field(:workflow_task_completed_event_id, 7,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )
end
