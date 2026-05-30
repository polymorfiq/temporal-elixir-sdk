defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCompletedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionCompletedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`new_execution_run_id`** | `string` | If another run is started by cron, this contains the new run id. |
  | 1 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized result of workflow completion (ie: The return value of the workflow function) |
  | 2 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :new_execution_run_id, 3, type: :string, json_name: "newExecutionRunId"
end
