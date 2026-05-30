defmodule Temporal.Protos.Temporal.Api.History.V1.StartChildWorkflowExecutionInitiatedEventAttributes do
  @moduledoc """
  Automatically generated module for StartChildWorkflowExecutionInitiatedEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 10 | **`control`** | `string` | Deprecated. |
  | 14 | **`cron_schedule`** | `string` | If this child runs on a cron schedule, it will appear here |
  | 15 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 19 | **`inherit_build_id`** | `bool` | If this is set, the child workflow inherits the Build ID of the parent. Otherwise, the assignment |
  | 30 | **`initial_skipped_duration`** | `Google.Protobuf.Duration` | Propagate the duration skipped to the child workflow. |
  | 5 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 16 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`namespace`** | `string` | Namespace of the child workflow. |
  | 18 | **`namespace_id`** | `string` |  |
  | 9 | **`parent_close_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy` | Default: PARENT_CLOSE_POLICY_TERMINATE. |
  | 20 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 13 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` |  |
  | 17 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 21 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | The propagated time-skipping configuration for the child workflow. |
  | 6 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new. |
  | 2 | **`workflow_id`** | `string` |  |
  | 12 | **`workflow_id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy` | Default: WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE. |
  | 7 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 11 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |
  | 8 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `inherit_build_id` (`bool`): If this is set, the child workflow inherits the Build ID of the parent. Otherwise, the assignment
      rules of the child's Task Queue will be used to independently assign a Build ID to it.
      Deprecated. Only considered for versioning v0.2.
    * `namespace` (`string`): Namespace of the child workflow.
      SDKs and UI tools should use `namespace` field but server must use `namespace_id` only.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :namespace_id, 18, type: :string, json_name: "namespaceId"
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

  field :control, 10, type: :string, deprecated: true

  field :workflow_task_completed_event_id, 11,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :workflow_id_reuse_policy, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true

  field :retry_policy, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :cron_schedule, 14, type: :string, json_name: "cronSchedule"
  field :header, 15, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :memo, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 17,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :inherit_build_id, 19, type: :bool, json_name: "inheritBuildId", deprecated: true
  field :priority, 20, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :time_skipping_config, 21,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"

  field :initial_skipped_duration, 30,
    type: Google.Protobuf.Duration,
    json_name: "initialSkippedDuration"
end
