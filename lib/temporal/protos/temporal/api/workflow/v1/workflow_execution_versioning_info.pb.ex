defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo do
  @moduledoc """
  Holds all the information about worker versioning for a particular workflow execution.
  Experimental. Versioning info is experimental and might change in the future.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior` | Versioning behavior determines how the server should treat this execution when workers are |
  | 9 | **`continue_as_new_initial_versioning_behavior`** | `Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior` | Experimental. |
  | 2 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` | The worker deployment that completed the last workflow task of this workflow execution. Must |
  | 4 | **`deployment_transition`** | `Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition` | When present, indicates the workflow is transitioning to a different deployment. Can |
  | 7 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The Worker Deployment Version that completed the last workflow task of this workflow execution. |
  | 8 | **`revision_number`** | `int64` | Monotonic counter reflecting the latest routing decision for this workflow execution. |
  | 5 | **`version`** | `string` | Deprecated. Use `deployment_version`. |
  | 6 | **`version_transition`** | `Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition` | When present, indicates the workflow is transitioning to a different deployment version |
  | 3 | **`versioning_override`** | `Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride` | Present if user has set an execution-specific versioning override. This override takes |

  ### Additional Notes

    * `behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior`): Versioning behavior determines how the server should treat this execution when workers are
      upgraded. When present it means this workflow execution is versioned; UNSPECIFIED means
      unversioned. See the comments in `VersioningBehavior` enum for more info about different
      behaviors.

      Child workflows or CaN executions **inherit** their parent/previous run's effective Versioning 
      Behavior and Version (except when the new execution runs on a task queue not belonging to the 
      same deployment version as the parent/previous run's task queue). The first workflow task will
      be dispatched according to the inherited behavior (or to the current version of the task-queue's 
      deployment in the case of AutoUpgrade.) After completion of their first workflow task the 
      Deployment Version and Behavior of the execution will update according to configuration on the worker.

      Note that `behavior` is overridden by `versioning_override` if the latter is present.
    * `continue_as_new_initial_versioning_behavior` (`Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior`): Experimental.
      If this workflow is the result of a continue-as-new, this field is set to the initial_versioning_behavior
      specified in that command.
      Only used for the initial task of this run and the initial task of any retries of this run.
      Not passed to children or to future continue-as-new.

      Note: In the first release of Upgrade-on-CaN, when the only ContinueAsNewVersioningBehavior was AutoUpgrade,
      a non-empty InheritedAutoUpgradeInfo meant that the workflow should start as AutoUpgrade. So for compatibility
      with ContinueAsNew history commands generated during that time, know that an UNSPECIFIED value here is equivalent
      to ContinueAsNewVersioningBehaviorAutoUpgrade if the behavior of the workflow is AutoUpgrade.
    * `deployment` (`Temporal.Protos.Temporal.Api.Deployment.V1.Deployment`): The worker deployment that completed the last workflow task of this workflow execution. Must
      be present if `behavior` is set. Absent value means no workflow task is completed, or the
      last workflow task was completed by an unversioned worker. Unversioned workers may still send
      a deployment value which will be stored here, so the right way to check if an execution is
      versioned if an execution is versioned or not is via the `behavior` field.
      Note that `deployment` is overridden by `versioning_override` if the latter is present.
      Deprecated. Use `deployment_version`.
    * `deployment_transition` (`Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition`): When present, indicates the workflow is transitioning to a different deployment. Can
      indicate one of the following transitions: unversioned -> versioned, versioned -> versioned
      on a different deployment, or versioned -> unversioned.
      Not applicable to workflows with PINNED behavior.
      When a workflow with AUTO_UPGRADE behavior creates a new workflow task, it will automatically
      start a transition to the task queue's current deployment if the task queue's current
      deployment is different from the workflow's deployment.
      If the AUTO_UPGRADE workflow is stuck due to backlogged activity or workflow tasks, those
      tasks will be redirected to the task queue's current deployment. As soon as a poller from
      that deployment is available to receive the task, the workflow will automatically start a
      transition to that deployment and continue execution there.
      A deployment transition can only exist while there is a pending or started workflow task.
      Once the pending workflow task completes on the transition's target deployment, the
      transition completes and the workflow's `deployment` and `behavior` fields are updated per
      the worker's task completion response.
      Pending activities will not start new attempts during a transition. Once the transition is
      completed, pending activities will start their next attempt on the new deployment.
      Deprecated. Use version_transition.
    * `deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The Worker Deployment Version that completed the last workflow task of this workflow execution.
      An absent value means no workflow task is completed, or the workflow is unversioned.
      If present, and `behavior` is UNSPECIFIED, the last task of this workflow execution was completed
      by a worker that is not using versioning but _is_ passing Deployment Name and Build ID.

      Child workflows or CaN executions **inherit** their parent/previous run's effective Versioning 
      Behavior and Version (except when the new execution runs on a task queue not belonging to the 
      same deployment version as the parent/previous run's task queue). The first workflow task will
      be dispatched according to the inherited behavior (or to the current version of the task-queue's 
      deployment in the case of AutoUpgrade.) After completion of their first workflow task the 
      Deployment Version and Behavior of the execution will update according to configuration on the worker.

      Note that if `versioning_override.behavior` is PINNED then `versioning_override.pinned_version`
      will override this value.
    * `revision_number` (`int64`): Monotonic counter reflecting the latest routing decision for this workflow execution.
      Used for staleness detection between history and matching when dispatching tasks to workers.
      Incremented when a workflow execution routes to a new deployment version, which happens
      when a worker of the new deployment version completes a workflow task.
      Note: Pinned tasks and sticky tasks send a value of 0 for this field since these tasks do not
      face the problem of inconsistent dispatching that arises from eventual consistency between
      task queues and their partitions.
    * `version_transition` (`Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition`): When present, indicates the workflow is transitioning to a different deployment version
      (which may belong to the same deployment name or another). Can indicate one of the following
      transitions: unversioned -> versioned, versioned -> versioned
      on a different deployment version, or versioned -> unversioned.
      Not applicable to workflows with PINNED behavior.
      When a workflow with AUTO_UPGRADE behavior creates a new workflow task, it will automatically
      start a transition to the task queue's current version if the task queue's current version is
      different from the workflow's current deployment version.
      If the AUTO_UPGRADE workflow is stuck due to backlogged activity or workflow tasks, those
      tasks will be redirected to the task queue's current version. As soon as a poller from
      that deployment version is available to receive the task, the workflow will automatically
      start a transition to that version and continue execution there.
      A version transition can only exist while there is a pending or started workflow task.
      Once the pending workflow task completes on the transition's target version, the
      transition completes and the workflow's `behavior`, and `deployment_version` fields are updated per the
      worker's task completion response.
      Pending activities will not start new attempts during a transition. Once the transition is
      completed, pending activities will start their next attempt on the new version.
    * `versioning_override` (`Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride`): Present if user has set an execution-specific versioning override. This override takes
      precedence over SDK-sent `behavior` (and `version` when override is PINNED). An
      override can be set when starting a new execution, as well as afterwards by calling the
      `UpdateWorkflowExecutionOptions` API.
      Pinned overrides are automatically inherited by child workflows, continue-as-new workflows,
      workflow retries, and cron workflows.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :behavior, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior, enum: true

  field :deployment, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true

  field :version, 5, type: :string, deprecated: true

  field :deployment_version, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :versioning_override, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"

  field :deployment_transition, 4,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition,
    json_name: "deploymentTransition",
    deprecated: true

  field :version_transition, 6,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition,
    json_name: "versionTransition"

  field :revision_number, 8, type: :int64, json_name: "revisionNumber"

  field :continue_as_new_initial_versioning_behavior, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "continueAsNewInitialVersioningBehavior",
    enum: true
end
