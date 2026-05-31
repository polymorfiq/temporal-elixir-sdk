defmodule Temporal.Protos.Temporal.Api.History.V1.ChildWorkflowExecutionFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:namespace, 2, type: :string)
  field(:namespace_id, 8, type: :string, json_name: "namespaceId")

  field(:workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:initiated_event_id, 5, type: :int64, json_name: "initiatedEventId")
  field(:started_event_id, 6, type: :int64, json_name: "startedEventId")

  field(:retry_state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )
end
