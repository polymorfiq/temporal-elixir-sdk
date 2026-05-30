defmodule Temporal.Protos.Temporal.Api.History.V1.TimerStartedEventAttributes do
  @moduledoc """
  Automatically generated module for TimerStartedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`start_to_fire_timeout`** | `Google.Protobuf.Duration` | How long until this timer fires |
  | 1 | **`timer_id`** | `string` | The worker/user assigned id for this timer |
  | 3 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `start_to_fire_timeout` (`Google.Protobuf.Duration`): How long until this timer fires

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :timer_id, 1, type: :string, json_name: "timerId"
  field :start_to_fire_timeout, 2, type: Google.Protobuf.Duration, json_name: "startToFireTimeout"

  field :workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
end
