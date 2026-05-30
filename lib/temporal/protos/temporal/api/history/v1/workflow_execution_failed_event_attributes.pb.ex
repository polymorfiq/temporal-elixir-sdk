defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionFailedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionFailedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Serialized result of workflow failure (ex: An exception thrown, or error returned) |
  | 4 | **`new_execution_run_id`** | `string` | If another run is started by cron or retry, this contains the new run id. |
  | 2 | **`retry_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.RetryState` |  |
  | 3 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure

  field :retry_state, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true

  field :workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :new_execution_run_id, 4, type: :string, json_name: "newExecutionRunId"
end
