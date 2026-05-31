defmodule Temporal.Protos.Temporal.Api.History.V1.RequestCancelExternalWorkflowExecutionFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cause, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.CancelExternalWorkflowExecutionFailedCause,
    enum: true
  )

  field(:workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:namespace, 3, type: :string)
  field(:namespace_id, 7, type: :string, json_name: "namespaceId")

  field(:workflow_execution, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:initiated_event_id, 5, type: :int64, json_name: "initiatedEventId")
  field(:control, 6, type: :string, deprecated: true)
end
