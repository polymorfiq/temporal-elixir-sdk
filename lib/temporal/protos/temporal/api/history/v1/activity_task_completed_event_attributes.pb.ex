defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCompletedEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskCompletedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | id of the worker that completed this task |
  | 1 | **`result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized results of the activity. IE: The return value of the activity function |
  | 2 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this completion corresponds to |
  | 3 | **`started_event_id`** | `int64` | The id of the `ACTIVITY_TASK_STARTED` event this completion corresponds to |
  | 5 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this workflow task. |

  ### Additional Notes

    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this workflow task.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :scheduled_event_id, 2, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 3, type: :int64, json_name: "startedEventId"
  field :identity, 4, type: :string

  field :worker_version, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
end
