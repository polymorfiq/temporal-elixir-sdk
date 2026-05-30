defmodule Temporal.Protos.Temporal.Api.Command.V1.StartChildWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for StartChildWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 10 | **`control`** | `string` |  |
  | 13 | **`cron_schedule`** | `string` | Establish a cron schedule for the child workflow. |
  | 14 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 17 | **`inherit_build_id`** | `bool` | If this is set, the child workflow inherits the Build ID of the parent. Otherwise, the assignment |
  | 5 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 15 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`namespace`** | `string` | Deprecated. Cross-namespace operations are disabled by default as of server 1.30.1. |
  | 9 | **`parent_close_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy` | Default: PARENT_CLOSE_POLICY_TERMINATE. |
  | 18 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. If this message is not present, or any fields are not |
  | 12 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` |  |
  | 16 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 6 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new. |
  | 2 | **`workflow_id`** | `string` |  |
  | 11 | **`workflow_id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy` | Default: WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE. |
  | 7 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 8 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `inherit_build_id` (`bool`): If this is set, the child workflow inherits the Build ID of the parent. Otherwise, the assignment
      rules of the child's Task Queue will be used to independently assign a Build ID to it.
      Deprecated. Only considered for versioning v0.2.
    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority metadata. If this message is not present, or any fields are not
      present, they inherit the values from the workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string, deprecated: true
  field :workflow_id, 2, type: :string, json_name: "workflowId"

  field :workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :task_queue, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :input, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :workflow_execution_timeout, 6,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"

  field :workflow_run_timeout, 7, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :workflow_task_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"

  field :parent_close_policy, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy,
    json_name: "parentClosePolicy",
    enum: true

  field :control, 10, type: :string

  field :workflow_id_reuse_policy, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true

  field :retry_policy, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :cron_schedule, 13, type: :string, json_name: "cronSchedule"
  field :header, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :memo, 15, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 16,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :inherit_build_id, 17, type: :bool, json_name: "inheritBuildId", deprecated: true
  field :priority, 18, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
end
