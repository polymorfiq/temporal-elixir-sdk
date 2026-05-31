defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)

  field(:retry_state, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )

  field(:workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:new_execution_run_id, 4, type: :string, json_name: "newExecutionRunId")
end
