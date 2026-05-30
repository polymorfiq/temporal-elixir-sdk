defmodule Temporal.Protos.Temporal.Api.Workflow.V1.ResetPointInfo do
  @moduledoc """
  ResetPointInfo records the workflow event id that is the first one processed by a given
  build id or binary checksum. A new reset point will be created if either build id or binary
  checksum changes (although in general only one or the other will be used at a time).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`binary_checksum`** | `string` | Deprecated. A worker binary version identifier. |
  | 7 | **`build_id`** | `string` | Worker build id. |
  | 4 | **`create_time`** | `Google.Protobuf.Timestamp` |  |
  | 5 | **`expire_time`** | `Google.Protobuf.Timestamp` | (-- api-linter: core::0214::resource-expiry=disabled |
  | 3 | **`first_workflow_task_completed_id`** | `int64` | Event ID of the first WorkflowTaskCompleted event processed by this worker build. |
  | 6 | **`resettable`** | `bool` | false if the reset point has pending childWFs/reqCancels/signalExternals. |
  | 2 | **`run_id`** | `string` | The first run ID in the execution chain that was touched by this worker build. |

  ### Additional Notes

    * `expire_time` (`Google.Protobuf.Timestamp`): (-- api-linter: core::0214::resource-expiry=disabled
          aip.dev/not-precedent: TTL is not defined for ResetPointInfo. --)
      The time that the run is deleted due to retention.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id, 7, type: :string, json_name: "buildId"
  field :binary_checksum, 1, type: :string, json_name: "binaryChecksum", deprecated: true
  field :run_id, 2, type: :string, json_name: "runId"

  field :first_workflow_task_completed_id, 3,
    type: :int64,
    json_name: "firstWorkflowTaskCompletedId"

  field :create_time, 4, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :expire_time, 5, type: Google.Protobuf.Timestamp, json_name: "expireTime"
  field :resettable, 6, type: :bool
end
