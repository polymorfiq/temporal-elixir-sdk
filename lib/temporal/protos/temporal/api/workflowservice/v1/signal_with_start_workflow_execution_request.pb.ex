defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWithStartWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for SignalWithStartWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 14 | **`control`** | `string` | Deprecated. |
  | 16 | **`cron_schedule`** | `string` | See https://docs.temporal.io/docs/content/what-is-a-temporal-cron-job/ |
  | 19 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 9 | **`identity`** | `string` | The identity of the worker/client |
  | 5 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments to the workflow. These are passed as arguments to the workflow function. |
  | 24 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the WorkflowExecutionStarted and WorkflowExecutionSignaled events. |
  | 17 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`namespace`** | `string` |  |
  | 26 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 10 | **`request_id`** | `string` | Used to de-dupe signal w/ start requests |
  | 15 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | Retry policy for the workflow |
  | 18 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 13 | **`signal_input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized value(s) to provide with the signal |
  | 12 | **`signal_name`** | `string` | The workflow author-defined name of the signal to send to the workflow |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` | The task queue to start this workflow on, if it will be started |
  | 27 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | Time-skipping configuration. If not set, time skipping is disabled. |
  | 23 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionInfo |
  | 25 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion. |
  | 6 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new |
  | 2 | **`workflow_id`** | `string` |  |
  | 22 | **`workflow_id_conflict_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy` | Defines how to resolve a workflow id conflict with a *running* workflow. |
  | 11 | **`workflow_id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy` | Defines whether to allow re-using the workflow id from a previously *closed* workflow. |
  | 7 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run |
  | 20 | **`workflow_start_delay`** | `Google.Protobuf.Duration` | Time to wait before dispatching the first workflow task. Cannot be used with `cron_schedule`. |
  | 8 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `user_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata`): Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionInfo
      for use by user interfaces to display the fixed as-of-start summary and details of the
      workflow.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion.
      To unset the override after the workflow is running, use UpdateWorkflowExecutionOptions.
    * `workflow_id_conflict_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy`): Defines how to resolve a workflow id conflict with a *running* workflow.
      The default policy is WORKFLOW_ID_CONFLICT_POLICY_USE_EXISTING.
      Note that WORKFLOW_ID_CONFLICT_POLICY_FAIL is an invalid option.

      See `workflow_id_reuse_policy` for handling a workflow id duplication with a *closed* workflow.
    * `workflow_id_reuse_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy`): Defines whether to allow re-using the workflow id from a previously *closed* workflow.
      The default policy is WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE.

      See `workflow_id_reuse_policy` for handling a workflow id duplication with a *running* workflow.
    * `workflow_start_delay` (`Google.Protobuf.Duration`): Time to wait before dispatching the first workflow task. Cannot be used with `cron_schedule`.
      Note that the signal will be delivered with the first workflow task. If the workflow gets
      another SignalWithStartWorkflow before the delay a workflow task will be dispatched immediately
      and the rest of the delay period will be ignored, even if that request also had a delay.
      Signal via SignalWorkflowExecution will not unblock the workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
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

  field :identity, 9, type: :string
  field :request_id, 10, type: :string, json_name: "requestId"

  field :workflow_id_reuse_policy, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy,
    json_name: "workflowIdReusePolicy",
    enum: true

  field :workflow_id_conflict_policy, 22,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy,
    json_name: "workflowIdConflictPolicy",
    enum: true

  field :signal_name, 12, type: :string, json_name: "signalName"

  field :signal_input, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "signalInput"

  field :control, 14, type: :string, deprecated: true

  field :retry_policy, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :cron_schedule, 16, type: :string, json_name: "cronSchedule"
  field :memo, 17, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 18,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :header, 19, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :workflow_start_delay, 20, type: Google.Protobuf.Duration, json_name: "workflowStartDelay"

  field :user_metadata, 23,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :links, 24, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link

  field :versioning_override, 25,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :priority, 26, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :time_skipping_config, 27,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
end
