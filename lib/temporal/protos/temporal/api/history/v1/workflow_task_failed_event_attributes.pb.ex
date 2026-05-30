defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowTaskFailedEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowTaskFailedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`base_run_id`** | `string` | The original run id of the workflow. For reset workflow. |
  | 9 | **`binary_checksum`** | `string` | Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv] |
  | 3 | **`cause`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause` |  |
  | 4 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The failure details |
  | 8 | **`fork_event_version`** | `int64` | Version of the event where the history branch was forked. Used by multi-cluster replication |
  | 5 | **`identity`** | `string` | If a worker explicitly failed this task, this field contains the worker's identity. |
  | 7 | **`new_run_id`** | `string` | If the workflow is being reset, the new run id. |
  | 1 | **`scheduled_event_id`** | `int64` | The id of the `WORKFLOW_TASK_SCHEDULED` event this task corresponds to |
  | 2 | **`started_event_id`** | `int64` | The id of the `WORKFLOW_TASK_STARTED` event this task corresponds to |
  | 10 | **`worker_version`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | Version info of the worker who processed this workflow task. If present, the `build_id` field |

  ### Additional Notes

    * `binary_checksum` (`string`): Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
      If a worker explicitly failed this task, its binary id
    * `fork_event_version` (`int64`): Version of the event where the history branch was forked. Used by multi-cluster replication
      during resets to identify the correct history branch.
    * `identity` (`string`): If a worker explicitly failed this task, this field contains the worker's identity.
      When the server generates the failure internally this field is set as 'history-service'.
    * `worker_version` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): Version info of the worker who processed this workflow task. If present, the `build_id` field
      within is also used as `binary_checksum`, which may be omitted in that case (it may also be
      populated to preserve compatibility).
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"
  field :cause, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowTaskFailedCause, enum: true
  field :failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :identity, 5, type: :string
  field :base_run_id, 6, type: :string, json_name: "baseRunId"
  field :new_run_id, 7, type: :string, json_name: "newRunId"
  field :fork_event_version, 8, type: :int64, json_name: "forkEventVersion"
  field :binary_checksum, 9, type: :string, json_name: "binaryChecksum", deprecated: true

  field :worker_version, 10,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "workerVersion",
    deprecated: true
end
