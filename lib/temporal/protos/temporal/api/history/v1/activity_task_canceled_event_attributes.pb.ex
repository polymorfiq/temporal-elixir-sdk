defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCanceledEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskCanceledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Additional information that the activity reported upon confirming cancellation |
  | 5 | **`identity`** | `string` | id of the worker who canceled this activity |
  | 2 | **`latest_cancel_requested_event_id`** | `int64` | id of the most recent `ACTIVITY_TASK_CANCEL_REQUESTED` event which refers to the same |
  | 3 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this cancel confirmation corresponds to |
  | 4 | **`started_event_id`** | `int64` | The id of the `ACTIVITY_TASK_STARTED` event this cancel confirmation corresponds to |
  | 6 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this workflow task. |

  ### Additional Notes

    * `latest_cancel_requested_event_id` (`int64`): id of the most recent `ACTIVITY_TASK_CANCEL_REQUESTED` event which refers to the same
      activity
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this workflow task.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :latest_cancel_requested_event_id, 2,
    type: :int64,
    json_name: "latestCancelRequestedEventId"

  field :scheduled_event_id, 3, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 4, type: :int64, json_name: "startedEventId"
  field :identity, 5, type: :string

  field :worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
end
