defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for StartWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 21 | **`completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Callbacks to be called by the server when this workflow reaches a terminal state. |
  | 18 | **`continued_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | These values will be available as ContinuedFailure and LastCompletionResult in the |
  | 13 | **`cron_schedule`** | `string` | See https://docs.temporal.io/docs/content/what-is-a-temporal-cron-job/ |
  | 28 | **`eager_worker_deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Deployment Options of the worker who will process the eager task. Passed when `request_eager_execution=true`. |
  | 16 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 9 | **`identity`** | `string` | The identity of the client who initiated this request |
  | 5 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized arguments to the workflow. These are passed as arguments to the workflow function. |
  | 19 | **`last_completion_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 24 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the workflow. |
  | 14 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`namespace`** | `string` |  |
  | 26 | **`on_conflict_options`** | `Temporal.Protos.Temporal.Api.Workflow.V1.OnConflictOptions` | Defines actions to be done to the existing running workflow when the conflict policy |
  | 27 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 17 | **`request_eager_execution`** | `bool` | Request to get the first workflow task inline in the response bypassing matching service and worker polling. |
  | 10 | **`request_id`** | `string` | A unique identifier for this start request. Typically UUIDv4. |
  | 12 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | The retry policy for the workflow. Will never exceed `workflow_execution_timeout`. |
  | 15 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 29 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | Time-skipping configuration. If not set, time skipping is disabled. |
  | 23 | **`user_metadata`** | `Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata` | Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionInfo |
  | 25 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion. |
  | 6 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new. |
  | 2 | **`workflow_id`** | `string` |  |
  | 22 | **`workflow_id_conflict_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy` | Defines how to resolve a workflow id conflict with a *running* workflow. |
  | 11 | **`workflow_id_reuse_policy`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy` | Defines whether to allow re-using the workflow id from a previously *closed* workflow. |
  | 7 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 20 | **`workflow_start_delay`** | `Google.Protobuf.Duration` | Time to wait before dispatching the first workflow task. Cannot be used with `cron_schedule`. |
  | 8 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `completion_callbacks` (`Temporal.Protos.Temporal.Api.Common.V1.Callback`): Callbacks to be called by the server when this workflow reaches a terminal state.
      If the workflow continues-as-new, these callbacks will be carried over to the new execution.
      Callback addresses must be whitelisted in the server's dynamic configuration.
    * `continued_failure` (`Temporal.Protos.Temporal.Api.Failure.V1.Failure`): These values will be available as ContinuedFailure and LastCompletionResult in the
      WorkflowExecutionStarted event and through SDKs. The are currently only used by the
      server itself (for the schedules feature) and are not intended to be exposed in
      StartWorkflowExecution.
    * `on_conflict_options` (`Temporal.Protos.Temporal.Api.Workflow.V1.OnConflictOptions`): Defines actions to be done to the existing running workflow when the conflict policy
      WORKFLOW_ID_CONFLICT_POLICY_USE_EXISTING is used. If not set (ie., nil value) or set to a
      empty object (ie., all options with default value), it won't do anything to the existing
      running workflow. If set, it will add a history event to the running workflow.
    * `request_eager_execution` (`bool`): Request to get the first workflow task inline in the response bypassing matching service and worker polling.
      If set to `true` the caller is expected to have a worker available and capable of processing the task.
      The returned task will be marked as started and is expected to be completed by the specified
      `workflow_task_timeout`.
    * `user_metadata` (`Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata`): Metadata on the workflow if it is started. This is carried over to the WorkflowExecutionInfo
      for use by user interfaces to display the fixed as-of-start summary and details of the
      workflow.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): If set, takes precedence over the Versioning Behavior sent by the SDK on Workflow Task completion.
      To unset the override after the workflow is running, use UpdateWorkflowExecutionOptions.
    * `workflow_id_conflict_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy`): Defines how to resolve a workflow id conflict with a *running* workflow.
      The default policy is WORKFLOW_ID_CONFLICT_POLICY_FAIL.

      See `workflow_id_reuse_policy` for handling a workflow id duplication with a *closed* workflow.
    * `workflow_id_reuse_policy` (`Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy`): Defines whether to allow re-using the workflow id from a previously *closed* workflow.
      The default policy is WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE.

      See `workflow_id_conflict_policy` for handling a workflow id duplication with a *running* workflow.
    * `workflow_start_delay` (`Google.Protobuf.Duration`): Time to wait before dispatching the first workflow task. Cannot be used with `cron_schedule`.
      If the workflow gets a signal before the delay, a workflow task will be dispatched and the rest
      of the delay will be ignored.

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

  field :retry_policy, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :cron_schedule, 13, type: :string, json_name: "cronSchedule"
  field :memo, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 15,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :header, 16, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :request_eager_execution, 17, type: :bool, json_name: "requestEagerExecution"

  field :continued_failure, 18,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "continuedFailure"

  field :last_completion_result, 19,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"

  field :workflow_start_delay, 20, type: Google.Protobuf.Duration, json_name: "workflowStartDelay"

  field :completion_callbacks, 21,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"

  field :user_metadata, 23,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.UserMetadata,
    json_name: "userMetadata"

  field :links, 24, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link

  field :versioning_override, 25,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :on_conflict_options, 26,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.OnConflictOptions,
    json_name: "onConflictOptions"

  field :priority, 27, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :eager_worker_deployment_options, 28,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "eagerWorkerDeploymentOptions"

  field :time_skipping_config, 29,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
end
