defmodule Temporal.Protos.Temporal.Api.Failure.V1.ChildWorkflowExecutionFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:initiated_event_id, 4, type: :int64, json_name: "initiatedEventId")
  field(:started_event_id, 5, type: :int64, json_name: "startedEventId")

  field(:retry_state, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )
end
