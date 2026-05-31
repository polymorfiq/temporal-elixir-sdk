defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCompletedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:new_execution_run_id, 3, type: :string, json_name: "newExecutionRunId")
end
