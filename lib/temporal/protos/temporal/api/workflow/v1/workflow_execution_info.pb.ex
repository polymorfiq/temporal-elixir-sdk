defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionInfo do
  @moduledoc """
  Hold basic information about a workflow execution.
  This structure is a part of visibility, and thus contain a limited subset of information.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 19 | **`assigned_build_id`** | `string` | The currently assigned build ID for this execution. Presence of this value means worker versioning is used |
  | 12 | **`auto_reset_points`** | `Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints` |  |
  | 4 | **`close_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 17 | **`execution_duration`** | `Google.Protobuf.Duration` | Workflow execution duration is defined as difference between close time and execution time. |
  | 9 | **`execution_time`** | `Google.Protobuf.Timestamp` |  |
  | 26 | **`external_payload_count`** | `int64` | Count of external payloads referenced in workflow history. |
  | 25 | **`external_payload_size_bytes`** | `int64` | Total size in bytes of all external payloads referenced in workflow history. |
  | 21 | **`first_run_id`** | `string` | The first run ID in the execution chain. |
  | 6 | **`history_length`** | `int64` |  |
  | 15 | **`history_size_bytes`** | `int64` |  |
  | 20 | **`inherited_build_id`** | `string` | Build ID inherited from a previous/parent execution. If present, assigned_build_id will be set to this, instead |
  | 10 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 16 | **`most_recent_worker_version_stamp`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp` | If set, the most recent worker version stamp that appeared in a workflow task completion |
  | 8 | **`parent_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 7 | **`parent_namespace_id`** | `string` |  |
  | 24 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata |
  | 18 | **`root_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Contains information about the root workflow execution. |
  | 11 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |
  | 3 | **`start_time`** | `Google.Protobuf.Timestamp` |  |
  | 14 | **`state_transition_count`** | `int64` |  |
  | 5 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus` |  |
  | 13 | **`task_queue`** | `string` |  |
  | 2 | **`type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |
  | 22 | **`versioning_info`** | `Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo` | Absent value means the workflow execution is not versioned. When present, the execution might |
  | 23 | **`worker_deployment_name`** | `string` | The name of Worker Deployment that completed the most recent workflow task. |

  ### Additional Notes

    * `assigned_build_id` (`string`): The currently assigned build ID for this execution. Presence of this value means worker versioning is used
      for this execution. Assigned build ID is selected based on Worker Versioning Assignment Rules
      when the first workflow task of the execution is scheduled. If the first workflow task fails and is scheduled
      again, the assigned build ID may change according to the latest versioning rules.
      Assigned build ID can also change in the middle of a execution if Compatible Redirect Rules are applied to
      this execution.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `execution_duration` (`Google.Protobuf.Duration`): Workflow execution duration is defined as difference between close time and execution time.
      This field is only populated if the workflow is closed.
    * `first_run_id` (`string`): The first run ID in the execution chain.
      Executions created via the following operations are considered to be in the same chain
      - ContinueAsNew
      - Workflow Retry
      - Workflow Reset
      - Cron Schedule
    * `inherited_build_id` (`string`): Build ID inherited from a previous/parent execution. If present, assigned_build_id will be set to this, instead
      of using the assignment rules.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `most_recent_worker_version_stamp` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp`): If set, the most recent worker version stamp that appeared in a workflow task completion
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]
    * `root_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): Contains information about the root workflow execution.
      The root workflow execution is defined as follows:
      1. A workflow without parent workflow is its own root workflow.
      2. A workflow that has a parent workflow has the same root workflow as its parent workflow.
      Note: workflows continued as new or reseted may or may not have parents, check examples below.

      Examples:
        Scenario 1: Workflow W1 starts child workflow W2, and W2 starts child workflow W3.
          - The root workflow of all three workflows is W1.
        Scenario 2: Workflow W1 starts child workflow W2, and W2 continued as new W3.
          - The root workflow of all three workflows is W1.
        Scenario 3: Workflow W1 continued as new W2.
          - The root workflow of W1 is W1 and the root workflow of W2 is W2.
        Scenario 4: Workflow W1 starts child workflow W2, and W2 is reseted, creating W3
          - The root workflow of all three workflows is W1.
        Scenario 5: Workflow W1 is reseted, creating W2.
          - The root workflow of W1 is W1 and the root workflow of W2 is W2.
    * `versioning_info` (`Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo`): Absent value means the workflow execution is not versioned. When present, the execution might
      be versioned or unversioned, depending on `versioning_info.behavior` and `versioning_info.versioning_override`.
      Experimental. Versioning info is experimental and might change in the future.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :execution, 1, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :type, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType
  field :start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :close_time, 4, type: Google.Protobuf.Timestamp, json_name: "closeTime"

  field :status, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkflowExecutionStatus,
    enum: true

  field :history_length, 6, type: :int64, json_name: "historyLength"
  field :parent_namespace_id, 7, type: :string, json_name: "parentNamespaceId"

  field :parent_execution, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "parentExecution"

  field :execution_time, 9, type: Google.Protobuf.Timestamp, json_name: "executionTime"
  field :memo, 10, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :auto_reset_points, 12,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints,
    json_name: "autoResetPoints"

  field :task_queue, 13, type: :string, json_name: "taskQueue"
  field :state_transition_count, 14, type: :int64, json_name: "stateTransitionCount"
  field :history_size_bytes, 15, type: :int64, json_name: "historySizeBytes"

  field :most_recent_worker_version_stamp, 16,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp,
    json_name: "mostRecentWorkerVersionStamp",
    deprecated: true

  field :execution_duration, 17, type: Google.Protobuf.Duration, json_name: "executionDuration"

  field :root_execution, 18,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "rootExecution"

  field :assigned_build_id, 19, type: :string, json_name: "assignedBuildId", deprecated: true
  field :inherited_build_id, 20, type: :string, json_name: "inheritedBuildId", deprecated: true
  field :first_run_id, 21, type: :string, json_name: "firstRunId"

  field :versioning_info, 22,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo,
    json_name: "versioningInfo"

  field :worker_deployment_name, 23, type: :string, json_name: "workerDeploymentName"
  field :priority, 24, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
  field :external_payload_size_bytes, 25, type: :int64, json_name: "externalPayloadSizeBytes"
  field :external_payload_count, 26, type: :int64, json_name: "externalPayloadCount"
end
