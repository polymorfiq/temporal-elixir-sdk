defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionStartedEventAttributes do
  @moduledoc """
  Always the first event in workflow history

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 18 | **`attempt`** | `int32` | Starting at 1, the number of times we have tried to execute this workflow |
  | 30 | **`completion_callbacks`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback` | Completion callbacks attached when this workflow was started. |
  | 10 | **`continued_execution_run_id`** | `string` | Run id of the previous workflow which continued-as-new or retried or cron executed into this |
  | 12 | **`continued_failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` |  |
  | 20 | **`cron_schedule`** | `string` | If this workflow runs on a cron schedule, it will appear here |
  | 40 | **`declined_target_version_upgrade`** | `Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade` | During a previous run of this workflow, the server may have notified the SDK |
  | 38 | **`eager_execution_accepted`** | `bool` | A boolean indicating whether the SDK has asked to eagerly execute the first workflow task for this workflow and |
  | 16 | **`first_execution_run_id`** | `string` | This is the very first runId along the chain of ContinueAsNew, Retry, Cron and Reset. |
  | 21 | **`first_workflow_task_backoff`** | `Google.Protobuf.Duration` | For a cron workflow, this contains the amount of time between when this iteration of |
  | 25 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 15 | **`identity`** | `string` | Identity of the client who requested this execution |
  | 39 | **`inherited_auto_upgrade_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo` | If present, the new workflow begins with AutoUpgrade behavior. Before dispatching the |
  | 32 | **`inherited_build_id`** | `string` | When present, this execution is assigned to the build ID of its parent or previous execution. |
  | 37 | **`inherited_pinned_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | If present, the new workflow should start on this version with pinned base behavior. |
  | 42 | **`initial_skipped_duration`** | `Google.Protobuf.Duration` | The time skipped by the previous execution that started this workflow. |
  | 11 | **`initiator`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator` |  |
  | 6 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | SDK will deserialize this and provide it as arguments to the workflow function |
  | 13 | **`last_completion_result`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 22 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 14 | **`original_execution_run_id`** | `string` | This is the run id when the WorkflowExecutionStarted event was written. |
  | 4 | **`parent_initiated_event_id`** | `int64` | EventID of the child execution initiated event in parent workflow |
  | 26 | **`parent_initiated_event_version`** | `int64` | Version of the child execution initiated event in parent workflow |
  | 34 | **`parent_pinned_worker_deployment_version`** | `string` | When present, it means this is a child workflow of a parent that is Pinned to this Worker |
  | 3 | **`parent_workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Contains information about parent workflow execution that initiated the child workflow these attributes belong to. |
  | 2 | **`parent_workflow_namespace`** | `string` | If this workflow is a child, the namespace our parent lives in. |
  | 27 | **`parent_workflow_namespace_id`** | `string` |  |
  | 24 | **`prev_auto_reset_points`** | `Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints` |  |
  | 35 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 17 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` |  |
  | 31 | **`root_workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Contains information about the root workflow execution. |
  | 23 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 29 | **`source_version_stamp`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | If this workflow intends to use anything other than the current overall default version for |
  | 5 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 41 | **`time_skipping_config`** | `Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig` | Initial time-skipping configuration for this workflow execution, recorded at start time. |
  | 33 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | Versioning override applied to this workflow when it was started. |
  | 19 | **`workflow_execution_expiration_time`** | `Google.Protobuf.Timestamp` | The absolute time at which the workflow will be timed out. |
  | 7 | **`workflow_execution_timeout`** | `Google.Protobuf.Duration` | Total workflow execution timeout including retries and continue as new. |
  | 28 | **`workflow_id`** | `string` | This field is new in 1.21. |
  | 8 | **`workflow_run_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow run. |
  | 9 | **`workflow_task_timeout`** | `Google.Protobuf.Duration` | Timeout of a single workflow task. |
  | 1 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `continued_execution_run_id` (`string`): Run id of the previous workflow which continued-as-new or retried or cron executed into this
      workflow.
    * `declined_target_version_upgrade` (`Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade`): During a previous run of this workflow, the server may have notified the SDK
      that the Target Worker Deployment Version changed, but the SDK declined to
      upgrade (e.g., by continuing-as-new with PINNED behavior). This field records
      the target version that was declined.

      This is a wrapper message to distinguish "never declined" (nil wrapper) from
      "declined an unversioned target" (non-nil wrapper with nil deployment_version).

      Used internally by the server during continue-as-new and retry.
      Should not be read or interpreted by SDKs.
    * `eager_execution_accepted` (`bool`): A boolean indicating whether the SDK has asked to eagerly execute the first workflow task for this workflow and
      eager execution was accepted by the server.
      Only populated by server with version >= 1.29.0.
    * `first_execution_run_id` (`string`): This is the very first runId along the chain of ContinueAsNew, Retry, Cron and Reset.
      Used to identify a chain.
    * `first_workflow_task_backoff` (`Google.Protobuf.Duration`): For a cron workflow, this contains the amount of time between when this iteration of
      the cron workflow was scheduled and when it should run next per its cron_schedule.
    * `inherited_auto_upgrade_info` (`Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo`): If present, the new workflow begins with AutoUpgrade behavior. Before dispatching the
      first workflow task, this field is set to the deployment version on which the parent/
      previous run was operating. This inheritance only happens when the task queues belong to
      the same deployment version. The first workflow task will then be dispatched to either
      this inherited deployment version, or the current deployment version of the task queue's
      Deployment. After the first workflow task, the effective behavior depends on worker-sent
      values in subsequent workflow tasks.

      Inheritance rules:
        - ContinueAsNew and child workflows: inherit AutoUpgrade behavior and deployment version
        - Cron: never inherits
        - Retry: inherits only if the retried run is effectively AutoUpgrade at the time of
          retry, and inherited AutoUpgrade behavior when it started (i.e. it is a child of an
          AutoUpgrade parent or ContinueAsNew of an AutoUpgrade run, running on the same
          deployment as the parent/previous run)

      Additional notes:
      - This field is mutually exclusive with `inherited_pinned_version`.
      - `versioning_override`, if present, overrides this field during routing decisions.
      - SDK implementations do not interact with this field and is only used internally by
        the server to ensure task routing correctness.
    * `inherited_build_id` (`string`): When present, this execution is assigned to the build ID of its parent or previous execution.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `inherited_pinned_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): If present, the new workflow should start on this version with pinned base behavior.
      Child of pinned parent will inherit the parent's version if the Child's Task Queue belongs to that version.

      A new run initiated by workflow ContinueAsNew of pinned run, will inherit the previous run's version if the
      new run's Task Queue belongs to that version.

      A new run initiated by workflow Cron will never inherit.

      A new run initiated by workflow Retry will only inherit if the retried run is effectively pinned at the time
      of retry, and the retried run inherited a pinned version when it started (ie. it is a child of a pinned
      parent, or a CaN of a pinned run, and is running on a Task Queue in the inherited version).

      Pinned override is inherited if Task Queue of new run is compatible with the override version.
      Override is inherited separately and takes precedence over inherited base version.

      Note: This field is mutually exclusive with inherited_auto_upgrade_info.
      Additionaly, versioning_override, if present, overrides this field during routing decisions.
    * `initial_skipped_duration` (`Google.Protobuf.Duration`): The time skipped by the previous execution that started this workflow.
      It can happen in cases of child workflows and continue-as-new workflows.
    * `original_execution_run_id` (`string`): This is the run id when the WorkflowExecutionStarted event was written.
      A workflow reset changes the execution run_id, but preserves this field.
    * `parent_initiated_event_version` (`int64`): Version of the child execution initiated event in parent workflow
      It should be used together with parent_initiated_event_id to identify
      a child initiated event for global namespace
    * `parent_pinned_worker_deployment_version` (`string`): When present, it means this is a child workflow of a parent that is Pinned to this Worker
      Deployment Version. In this case, child workflow will start as Pinned to this Version instead
      of starting on the Current Version of its Task Queue.
      This is set only if the child workflow is starting on a Task Queue belonging to the same
      Worker Deployment Version.
      Deprecated. Use `parent_versioning_info`.
    * `parent_workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): Contains information about parent workflow execution that initiated the child workflow these attributes belong to.
      If the workflow these attributes belong to is not a child workflow of any other execution, this field will not be populated.
    * `parent_workflow_namespace` (`string`): If this workflow is a child, the namespace our parent lives in.
      SDKs and UI tools should use `parent_workflow_namespace` field but server must use `parent_workflow_namespace_id` only.
    * `root_workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): Contains information about the root workflow execution.
      The root workflow execution is defined as follows:
        1. A workflow without parent workflow is its own root workflow.
        2. A workflow that has a parent workflow has the same root workflow as its parent workflow.
      When the workflow is its own root workflow, then root_workflow_execution is nil.
      Note: workflows continued as new or reseted may or may not have parents, check examples below.

      Examples:
        Scenario 1: Workflow W1 starts child workflow W2, and W2 starts child workflow W3.
          - The root workflow of all three workflows is W1.
          - W1 has root_workflow_execution set to nil.
          - W2 and W3 have root_workflow_execution set to W1.
        Scenario 2: Workflow W1 starts child workflow W2, and W2 continued as new W3.
          - The root workflow of all three workflows is W1.
          - W1 has root_workflow_execution set to nil.
          - W2 and W3 have root_workflow_execution set to W1.
        Scenario 3: Workflow W1 continued as new W2.
          - The root workflow of W1 is W1 and the root workflow of W2 is W2.
          - W1 and W2 have root_workflow_execution set to nil.
        Scenario 4: Workflow W1 starts child workflow W2, and W2 is reseted, creating W3
          - The root workflow of all three workflows is W1.
          - W1 has root_workflow_execution set to nil.
          - W2 and W3 have root_workflow_execution set to W1.
        Scenario 5: Workflow W1 is reseted, creating W2.
          - The root workflow of W1 is W1 and the root workflow of W2 is W2.
          - W1 and W2 have root_workflow_execution set to nil.
    * `source_version_stamp` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): If this workflow intends to use anything other than the current overall default version for
      the queue, then we include it here.
      Deprecated. [cleanup-experimental-wv]
    * `time_skipping_config` (`Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig`): Initial time-skipping configuration for this workflow execution, recorded at start time.
      This may have been set explicitly via the start workflow request, or propagated from a
      parent/previous execution.

      The configuration may be updated after start via UpdateWorkflowExecutionOptions, which
      will be reflected in the WorkflowExecutionOptionsUpdatedEvent.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): Versioning override applied to this workflow when it was started.
      Children, crons, retries, and continue-as-new will inherit source run's override if pinned
      and if the new workflow's Task Queue belongs to the override version.
    * `workflow_execution_expiration_time` (`Google.Protobuf.Timestamp`): The absolute time at which the workflow will be timed out.
      This is passed without change to the next run/retry of a workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_type, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :parent_workflow_namespace, 2, type: :string, json_name: "parentWorkflowNamespace"
  field :parent_workflow_namespace_id, 27, type: :string, json_name: "parentWorkflowNamespaceId"

  field :parent_workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "parentWorkflowExecution"

  field :parent_initiated_event_id, 4, type: :int64, json_name: "parentInitiatedEventId"

  field :task_queue, 5,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :input, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :workflow_execution_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"

  field :workflow_run_timeout, 8, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout"

  field :workflow_task_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"

  field :continued_execution_run_id, 10, type: :string, json_name: "continuedExecutionRunId"

  field :initiator, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true

  field :continued_failure, 12,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "continuedFailure"

  field :last_completion_result, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"

  field :original_execution_run_id, 14, type: :string, json_name: "originalExecutionRunId"
  field :identity, 15, type: :string
  field :first_execution_run_id, 16, type: :string, json_name: "firstExecutionRunId"

  field :retry_policy, 17,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :attempt, 18, type: :int32

  field :workflow_execution_expiration_time, 19,
    type: Google.Protobuf.Timestamp,
    json_name: "workflowExecutionExpirationTime"

  field :cron_schedule, 20, type: :string, json_name: "cronSchedule"

  field :first_workflow_task_backoff, 21,
    type: Google.Protobuf.Duration,
    json_name: "firstWorkflowTaskBackoff"

  field :memo, 22, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 23,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :prev_auto_reset_points, 24,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints,
    json_name: "prevAutoResetPoints"

  field :header, 25, type: Temporal.Protos.Temporal.Api.Common.V1.Header

  field :parent_initiated_event_version, 26,
    type: :int64,
    json_name: "parentInitiatedEventVersion"

  field :workflow_id, 28, type: :string, json_name: "workflowId"

  field :source_version_stamp, 29,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "sourceVersionStamp",
    deprecated: true

  field :completion_callbacks, 30,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"

  field :root_workflow_execution, 31,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "rootWorkflowExecution"

  field :inherited_build_id, 32, type: :string, json_name: "inheritedBuildId", deprecated: true

  field :versioning_override, 33,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :parent_pinned_worker_deployment_version, 34,
    type: :string,
    json_name: "parentPinnedWorkerDeploymentVersion",
    deprecated: true

  field :priority, 35, type: Temporal.Protos.Temporal.Api.Common.V1.Priority

  field :inherited_pinned_version, 37,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "inheritedPinnedVersion"

  field :inherited_auto_upgrade_info, 39,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo,
    json_name: "inheritedAutoUpgradeInfo"

  field :eager_execution_accepted, 38, type: :bool, json_name: "eagerExecutionAccepted"

  field :declined_target_version_upgrade, 40,
    type: Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade,
    json_name: "declinedTargetVersionUpgrade"

  field :time_skipping_config, 41,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"

  field :initial_skipped_duration, 42,
    type: Google.Protobuf.Duration,
    json_name: "initialSkippedDuration"
end
