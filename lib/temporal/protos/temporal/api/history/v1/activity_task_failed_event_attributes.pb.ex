defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskFailedEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskFailedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Failure details |
  | 4 | **`identity`** | `string` | id of the worker that failed this task |
  | 5 | **`retry_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.RetryState` |  |
  | 2 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this failure corresponds to |
  | 3 | **`started_event_id`** | `int64` | The id of the `ACTIVITY_TASK_STARTED` event this failure corresponds to |
  | 6 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this workflow task. |

  ### Additional Notes

    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this workflow task.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :scheduled_event_id, 2, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 3, type: :int64, json_name: "startedEventId"
  field :identity, 4, type: :string

  field :retry_state, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true

  field :worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
end
