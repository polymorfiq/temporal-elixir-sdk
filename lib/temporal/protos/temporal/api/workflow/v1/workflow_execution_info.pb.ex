defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:execution, 1, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:type, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType)
  field(:start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:close_time, 4, type: Google.Protobuf.Timestamp, json_name: "closeTime")

  field(:status, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true
  )

  field(:history_length, 6, type: :int64, json_name: "historyLength")
  field(:parent_namespace_id, 7, type: :string, json_name: "parentNamespaceId")

  field(:parent_execution, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "parentExecution"
  )

  field(:execution_time, 9, type: Google.Protobuf.Timestamp, json_name: "executionTime")
  field(:memo, 10, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:auto_reset_points, 12,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints,
    json_name: "autoResetPoints"
  )

  field(:task_queue, 13, type: :string, json_name: "taskQueue")
  field(:state_transition_count, 14, type: :int64, json_name: "stateTransitionCount")
  field(:history_size_bytes, 15, type: :int64, json_name: "historySizeBytes")

  field(:most_recent_worker_version_stamp, 16,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "mostRecentWorkerVersionStamp",
    deprecated: true
  )

  field(:execution_duration, 17, type: Google.Protobuf.Duration, json_name: "executionDuration")

  field(:root_execution, 18,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "rootExecution"
  )

  field(:assigned_build_id, 19, type: :string, json_name: "assignedBuildId", deprecated: true)
  field(:inherited_build_id, 20, type: :string, json_name: "inheritedBuildId", deprecated: true)
  field(:first_run_id, 21, type: :string, json_name: "firstRunId")

  field(:versioning_info, 22,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo,
    json_name: "versioningInfo"
  )

  field(:worker_deployment_name, 23, type: :string, json_name: "workerDeploymentName")
  field(:priority, 24, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
  field(:external_payload_size_bytes, 25, type: :int64, json_name: "externalPayloadSizeBytes")
  field(:external_payload_count, 26, type: :int64, json_name: "externalPayloadCount")
end
