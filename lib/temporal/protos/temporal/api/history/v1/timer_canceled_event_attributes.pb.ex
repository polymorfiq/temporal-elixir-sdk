defmodule Temporal.Protos.Temporal.Api.History.V1.TimerCanceledEventAttributes do
  @moduledoc """
  Automatically generated module for TimerCanceledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | The id of the worker who requested this cancel |
  | 2 | **`started_event_id`** | `int64` | The id of the `TIMER_STARTED` event itself |
  | 1 | **`timer_id`** | `string` | Will match the `timer_id` from `TIMER_STARTED` event for this timer |
  | 3 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :timer_id, 1, type: :string, json_name: "timerId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"

  field :workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :identity, 4, type: :string
end
