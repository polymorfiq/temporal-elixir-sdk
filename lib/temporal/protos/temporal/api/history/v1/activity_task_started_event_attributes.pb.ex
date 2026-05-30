defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskStartedEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskStartedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`attempt`** | `int32` | Starting at 1, the number of times this task has been attempted |
  | 7 | **`build_id_redirect_counter`** | `int64` | Used by server internally to properly reapply build ID redirects to an execution |
  | 2 | **`identity`** | `string` | id of the worker that picked up this task |
  | 5 | **`last_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | Will be set to the most recent failure details, if this task has previously failed and then |
  | 3 | **`request_id`** | `string` | This field is populated from the RecordActivityTaskStartedRequest. Matching service would |
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `ACTIVITY_TASK_SCHEDULED` event this task corresponds to |
  | 6 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker to whom this task was dispatched. |

  ### Additional Notes

    * `build_id_redirect_counter` (`int64`): Used by server internally to properly reapply build ID redirects to an execution
      when rebuilding it from events.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `last_failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): Will be set to the most recent failure details, if this task has previously failed and then
      been retried.
    * `request_id` (`string`): This field is populated from the RecordActivityTaskStartedRequest. Matching service would
      set the request_id on the RecordActivityTaskStartedRequest to a new UUID. This is useful
      in case a RecordActivityTaskStarted call succeed but matching doesn't get that response,
      so matching could retry and history service would return success if the request_id matches.
      In that case, matching will continue to deliver the task to worker. Without this field, history
      service would return AlreadyStarted error, and matching would drop the task.
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker to whom this task was dispatched.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :identity, 2, type: :string
  field :request_id, 3, type: :string, json_name: "requestId"
  field :attempt, 4, type: :int32

  field :last_failure, 5,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "lastFailure"

  field :worker_version, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true

  field :build_id_redirect_counter, 7,
    type: :int64,
    json_name: "buildIdRedirectCounter",
    deprecated: true
end
