defmodule Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo do
  @moduledoc """
  NewWorkflowExecutionInfo is a shared message that encapsulates all the
  required arguments to starting a workflow in different contexts.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 10 | **`cron_schedule`** | `string` | See https://docs.temporal.io/docs/content/what-is-a-temporal-cron-job/ |
  | 13 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 4 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments to the workflow. |
  | 11 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 16 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 9 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | The retry policy for the workflow. Will never exceed `workflow_execution_timeout`. |
  | 12 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 3 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 14 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionConfig |
  | 15 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion. |
  | 5 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new. |
  | 1 | **`workflow_id`** | `string` |  |
  | 8 | **`workflow_id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy` | Default: WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE. |
  | 6 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 7 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 2 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `user_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata`): Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionConfig
      for use by user interfaces to display the fixed as-of-start summary and details of the
      workflow.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion.
      To unset the override after the workflow is running, use UpdateWorkflowExecutionOptions.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_id, 1, type: :string, json_name: "workflowId"

  field :workflow_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :workflow_execution_timeout, 5,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"

  field :workflow_run_timeout, 6, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :workflow_task_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"

  field :workflow_id_reuse_policy, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true

  field :retry_policy, 9,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :cron_schedule, 10, type: :string, json_name: "cronSchedule"
  field :memo, 11, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :header, 13, type: Temporal.Protos.Temporal.Api.Common.V1.Header

  field :user_metadata, 14,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :versioning_override, 15,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :priority, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
end
