defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for ResetWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 9 | **`identity`** | `string` | The identity of the worker/client |
  | 1 | **`namespace`** | `string` |  |
  | 8 | **`post_reset_operations`** | `Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation` | Operations to perform after the workflow has been reset. These operations will be applied |
  | 3 | **`reason`** | `string` |  |
  | 5 | **`request_id`** | `string` | Used to de-dupe reset requests |
  | 7 | **`reset_reapply_exclude_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType` | Event types not to be reapplied |
  | 6 | **`reset_reapply_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType` | Deprecated. Use `options`. |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | The workflow to reset. If this contains a run ID then the workflow will be reset back to the |
  | 4 | **`workflow_task_finish_event_id`** | `int64` | The id of a `WORKFLOW_TASK_COMPLETED`,`WORKFLOW_TASK_TIMED_OUT`, `WORKFLOW_TASK_FAILED`, or |

  ### Additional Notes

    * `post_reset_operations` (`Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation`): Operations to perform after the workflow has been reset. These operations will be applied
      to the *new* run of the workflow execution in the order they are provided.
      All operations are applied to the workflow before the first new workflow task is generated
    * `reset_reapply_type` (`Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType`): Deprecated. Use `options`.
      Default: RESET_REAPPLY_TYPE_SIGNAL
    * `workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): The workflow to reset. If this contains a run ID then the workflow will be reset back to the
      provided event ID in that run. Otherwise it will be reset to the provided event ID in the
      current run. In all cases the current run will be terminated and a new run started.
    * `workflow_task_finish_event_id` (`int64`): The id of a `WORKFLOW_TASK_COMPLETED`,`WORKFLOW_TASK_TIMED_OUT`, `WORKFLOW_TASK_FAILED`, or
      `WORKFLOW_TASK_STARTED` event to reset to.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :reason, 3, type: :string
  field :workflow_task_finish_event_id, 4, type: :int64, json_name: "workflowTaskFinishEventId"
  field :request_id, 5, type: :string, json_name: "requestId"

  field :reset_reapply_type, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true

  field :reset_reapply_exclude_types, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType,
    json_name: "resetReapplyExcludeTypes",
    enum: true

  field :post_reset_operations, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation,
    json_name: "postResetOperations"

  field :identity, 9, type: :string
end
