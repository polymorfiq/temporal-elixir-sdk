defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_type, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:parent_workflow_namespace, 2, type: :string, json_name: "parentWorkflowNamespace")
  field(:parent_workflow_namespace_id, 27, type: :string, json_name: "parentWorkflowNamespaceId")

  field(:parent_workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "parentWorkflowExecution"
  )

  field(:parent_initiated_event_id, 4, type: :int64, json_name: "parentInitiatedEventId")

  field(:task_queue, 5,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:input, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:workflow_execution_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionTimeout"
  )

  field(:workflow_run_timeout, 8, type: Google.Protobuf.Duration, json_name: "workflowRunTimeout")

  field(:workflow_task_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "workflowTaskTimeout"
  )

  field(:continued_execution_run_id, 10, type: :string, json_name: "continuedExecutionRunId")

  field(:initiator, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewInitiator,
    enum: true
  )

  field(:continued_failure, 12,
    type: Temporal.Protos.Temporal.Api.Failure.V1.Failure,
    json_name: "continuedFailure"
  )

  field(:last_completion_result, 13,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "lastCompletionResult"
  )

  field(:original_execution_run_id, 14, type: :string, json_name: "originalExecutionRunId")
  field(:identity, 15, type: :string)
  field(:first_execution_run_id, 16, type: :string, json_name: "firstExecutionRunId")

  field(:retry_policy, 17,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:attempt, 18, type: :int32)

  field(:workflow_execution_expiration_time, 19,
    type: Google.Protobuf.Timestamp,
    json_name: "workflowExecutionExpirationTime"
  )

  field(:cron_schedule, 20, type: :string, json_name: "cronSchedule")

  field(:first_workflow_task_backoff, 21,
    type: Google.Protobuf.Duration,
    json_name: "firstWorkflowTaskBackoff"
  )

  field(:memo, 22, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 23,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:prev_auto_reset_points, 24,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints,
    json_name: "prevAutoResetPoints"
  )

  field(:header, 25, type: Temporal.Protos.Temporal.Api.Common.V1.Header)

  field(:parent_initiated_event_version, 26,
    type: :int64,
    json_name: "parentInitiatedEventVersion"
  )

  field(:workflow_id, 28, type: :string, json_name: "workflowId")

  field(:source_version_stamp, 29,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "sourceVersionStamp",
    deprecated: true
  )

  field(:completion_callbacks, 30,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback,
    json_name: "completionCallbacks"
  )

  field(:root_workflow_execution, 31,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "rootWorkflowExecution"
  )

  field(:inherited_build_id, 32, type: :string, json_name: "inheritedBuildId", deprecated: true)

  field(:versioning_override, 33,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:parent_pinned_worker_deployment_version, 34,
    type: :string,
    json_name: "parentPinnedWorkerDeploymentVersion",
    deprecated: true
  )

  field(:priority, 35, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)

  field(:inherited_pinned_version, 37,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "inheritedPinnedVersion"
  )

  field(:inherited_auto_upgrade_info, 39,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo,
    json_name: "inheritedAutoUpgradeInfo"
  )

  field(:eager_execution_accepted, 38, type: :bool, json_name: "eagerExecutionAccepted")

  field(:declined_target_version_upgrade, 40,
    type: Temporal.Protos.Temporal.Api.History.V1.DeclinedTargetVersionUpgrade,
    json_name: "declinedTargetVersionUpgrade"
  )

  field(:time_skipping_config, 41,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.TimeSkippingConfig,
    json_name: "timeSkippingConfig"
  )

  field(:initial_skipped_duration, 42,
    type: Google.Protobuf.Duration,
    json_name: "initialSkippedDuration"
  )
end
