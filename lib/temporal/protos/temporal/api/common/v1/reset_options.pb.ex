defmodule Temporal.Protos.Temporal.Api.Common.V1.ResetOptions do
  @moduledoc """
  Describes where and how to reset a workflow, used for batch reset currently
  and may be used for single-workflow reset later.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`build_id`** | `string` | Resets to the first workflow task processed by this build id. |
  | 11 | **`current_run_only`** | `bool` | If true, limit the reset to only within the current run. (Applies to build_id targets and |
  | 1 | **`first_workflow_task`** | `Google.Protobuf.Empty` | Resets to the first workflow task completed or started event. |
  | 2 | **`last_workflow_task`** | `Google.Protobuf.Empty` | Resets to the last workflow task completed or started event. |
  | 12 | **`reset_reapply_exclude_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType` | Event types not to be reapplied |
  | 10 | **`reset_reapply_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType` | Deprecated. Use `options`. |
  | 3 | **`workflow_task_id`** | `int64` | The id of a specific `WORKFLOW_TASK_COMPLETED`,`WORKFLOW_TASK_TIMED_OUT`, `WORKFLOW_TASK_FAILED`, or |

  ### Additional Notes

    * `build_id` (`string`): Resets to the first workflow task processed by this build id.
      If the workflow was not processed by the build id, or the workflow task can't be
      determined, no reset will be performed.
      Note that by default, this reset is allowed to be to a prior run in a chain of
      continue-as-new.
    * `current_run_only` (`bool`): If true, limit the reset to only within the current run. (Applies to build_id targets and
      possibly others in the future.)
    * `reset_reapply_type` (`Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType`): Deprecated. Use `options`.
      Default: RESET_REAPPLY_TYPE_SIGNAL
    * `workflow_task_id` (`int64`): The id of a specific `WORKFLOW_TASK_COMPLETED`,`WORKFLOW_TASK_TIMED_OUT`, `WORKFLOW_TASK_FAILED`, or
      `WORKFLOW_TASK_STARTED` event to reset to.
      Note that this option doesn't make sense when used as part of a batch request.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :target, 0

  field :first_workflow_task, 1,
    type: Google.Protobuf.Empty,
    json_name: "firstWorkflowTask",
    oneof: 0

  field :last_workflow_task, 2,
    type: Google.Protobuf.Empty,
    json_name: "lastWorkflowTask",
    oneof: 0

  field :workflow_task_id, 3, type: :int64, json_name: "workflowTaskId", oneof: 0
  field :build_id, 4, type: :string, json_name: "buildId", oneof: 0

  field :reset_reapply_type, 10,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true

  field :current_run_only, 11, type: :bool, json_name: "currentRunOnly"

  field :reset_reapply_exclude_types, 12,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType,
    json_name: "resetReapplyExcludeTypes",
    enum: true
end
