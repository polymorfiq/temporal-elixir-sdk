defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskTimedOutEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowTaskTimedOutEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `WORKFLOW_TASK_SCHEDULED` event this task corresponds to |
  | 2 | **`started_event_id`** | `int64` | The id of the `WORKFLOW_TASK_STARTED` event this task corresponds to |
  | 3 | **`timeout_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TimeoutType` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"

  field :timeout_type, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TimeoutType,
    json_name: "timeoutType",
    enum: true
end
