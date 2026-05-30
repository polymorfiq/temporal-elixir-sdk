defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCanceledEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionCanceledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 1 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_task_completed_event_id, 1,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
