defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat do
  @moduledoc """
  Worker info message, contains information about the worker and its current state.
  All information is provided by the worker itself.
  (-- api-linter: core::0140::prepositions=disabled
      aip.dev/not-precedent: Removing those words make names less clear. --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 18 | **`activity_poller_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo` |  |
  | 13 | **`activity_task_slots_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo` |  |
  | 22 | **`current_sticky_cache_size`** | `int32` | Current cache size, expressed in number of Workflow Executions. |
  | 5 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` |  |
  | 24 | **`drivers`** | `Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo` | Storage drivers in use by this SDK. |
  | 11 | **`elapsed_since_last_heartbeat`** | `Google.Protobuf.Duration` | Elapsed time since the last heartbeat from the worker. |
  | 10 | **`heartbeat_time`** | `Google.Protobuf.Timestamp` | Timestamp of this heartbeat, coming from the worker. Worker should set it to "now". |
  | 3 | **`host_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerHostInfo` | Worker host information. |
  | 15 | **`local_activity_slots_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo` |  |
  | 19 | **`nexus_poller_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo` |  |
  | 14 | **`nexus_task_slots_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo` |  |
  | 23 | **`plugins`** | `Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo` | Plugins currently in use by this SDK. |
  | 6 | **`sdk_name`** | `string` |  |
  | 7 | **`sdk_version`** | `string` |  |
  | 9 | **`start_time`** | `Google.Protobuf.Timestamp` | Worker start time. |
  | 8 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus` | Worker status. Defined by SDK. |
  | 4 | **`task_queue`** | `string` | Task queue this worker is polling for tasks. |
  | 20 | **`total_sticky_cache_hit`** | `int32` | A Workflow Task found a cached Workflow Execution to run against. |
  | 21 | **`total_sticky_cache_miss`** | `int32` | A Workflow Task did not find a cached Workflow execution to run against. |
  | 2 | **`worker_identity`** | `string` | Worker identity, set by the client, may not be unique. |
  | 1 | **`worker_instance_key`** | `string` | Worker identifier, should be unique for the namespace. |
  | 16 | **`workflow_poller_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo` |  |
  | 17 | **`workflow_sticky_poller_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo` |  |
  | 12 | **`workflow_task_slots_info`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo` |  |

  ### Additional Notes

    * `heartbeat_time` (`Google.Protobuf.Timestamp`): Timestamp of this heartbeat, coming from the worker. Worker should set it to "now".
      Note that this timestamp comes directly from the worker and is subject to workers' clock skew.
    * `start_time` (`Google.Protobuf.Timestamp`): Worker start time.
      It can be used to determine worker uptime. (current time - start time)
    * `worker_identity` (`string`): Worker identity, set by the client, may not be unique.
      Usually host_name+(user group name)+process_id, but can be overwritten by the user.
    * `worker_instance_key` (`string`): Worker identifier, should be unique for the namespace.
      It is distinct from worker identity, which is not necessarily namespace-unique.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_instance_key, 1, type: :string, json_name: "workerInstanceKey"
  field :worker_identity, 2, type: :string, json_name: "workerIdentity"

  field :host_info, 3,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHostInfo,
    json_name: "hostInfo"

  field :task_queue, 4, type: :string, json_name: "taskQueue"

  field :deployment_version, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :sdk_name, 6, type: :string, json_name: "sdkName"
  field :sdk_version, 7, type: :string, json_name: "sdkVersion"
  field :status, 8, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus, enum: true
  field :start_time, 9, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :heartbeat_time, 10, type: Google.Protobuf.Timestamp, json_name: "heartbeatTime"

  field :elapsed_since_last_heartbeat, 11,
    type: Google.Protobuf.Duration,
    json_name: "elapsedSinceLastHeartbeat"

  field :workflow_task_slots_info, 12,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo,
    json_name: "workflowTaskSlotsInfo"

  field :activity_task_slots_info, 13,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo,
    json_name: "activityTaskSlotsInfo"

  field :nexus_task_slots_info, 14,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo,
    json_name: "nexusTaskSlotsInfo"

  field :local_activity_slots_info, 15,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerSlotsInfo,
    json_name: "localActivitySlotsInfo"

  field :workflow_poller_info, 16,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo,
    json_name: "workflowPollerInfo"

  field :workflow_sticky_poller_info, 17,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo,
    json_name: "workflowStickyPollerInfo"

  field :activity_poller_info, 18,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo,
    json_name: "activityPollerInfo"

  field :nexus_poller_info, 19,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo,
    json_name: "nexusPollerInfo"

  field :total_sticky_cache_hit, 20, type: :int32, json_name: "totalStickyCacheHit"
  field :total_sticky_cache_miss, 21, type: :int32, json_name: "totalStickyCacheMiss"
  field :current_sticky_cache_size, 22, type: :int32, json_name: "currentStickyCacheSize"
  field :plugins, 23, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo

  field :drivers, 24,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo
end
