defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerListInfo do
  @moduledoc """
  Limited worker information returned in the list response.
  When adding fields here, ensure that it is also added to WorkerInfo (as it carries the full worker information).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` |  |
  | 13 | **`drivers`** | `Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo` | Storage drivers in use by this SDK. |
  | 9 | **`host_name`** | `string` | Worker host identifier. |
  | 12 | **`plugins`** | `Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo` | Plugins currently in use by this SDK. |
  | 11 | **`process_id`** | `string` | Worker process identifier. This id only needs to be unique |
  | 5 | **`sdk_name`** | `string` |  |
  | 6 | **`sdk_version`** | `string` |  |
  | 8 | **`start_time`** | `Google.Protobuf.Timestamp` | Worker start time. |
  | 7 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus` | Worker status. Defined by SDK. |
  | 3 | **`task_queue`** | `string` | Task queue this worker is polling for tasks. |
  | 10 | **`worker_grouping_key`** | `string` | Worker grouping identifier. A key to group workers that share the same client+namespace+process. |
  | 2 | **`worker_identity`** | `string` | Worker identity, set by the client, may not be unique. |
  | 1 | **`worker_instance_key`** | `string` | Worker identifier, should be unique for the namespace. |

  ### Additional Notes

    * `process_id` (`string`): Worker process identifier. This id only needs to be unique
      within one host (so using e.g. a unix pid would be appropriate).
    * `start_time` (`Google.Protobuf.Timestamp`): Worker start time.
      It can be used to determine worker uptime. (current time - start time)
    * `worker_grouping_key` (`string`): Worker grouping identifier. A key to group workers that share the same client+namespace+process.
      This will be used to build the worker command nexus task queue name:
      "temporal-sys/worker-commands/{worker_grouping_key}"
    * `worker_identity` (`string`): Worker identity, set by the client, may not be unique.
      Usually host_name+(user group name)+process_id, but can be overwritten by the user.
    * `worker_instance_key` (`string`): Worker identifier, should be unique for the namespace.
      It is distinct from worker identity, which is not necessarily namespace-unique.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :worker_instance_key, 1, type: :string, json_name: "workerInstanceKey"
  field :worker_identity, 2, type: :string, json_name: "workerIdentity"
  field :task_queue, 3, type: :string, json_name: "taskQueue"

  field :deployment_version, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :sdk_name, 5, type: :string, json_name: "sdkName"
  field :sdk_version, 6, type: :string, json_name: "sdkVersion"
  field :status, 7, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus, enum: true
  field :start_time, 8, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :host_name, 9, type: :string, json_name: "hostName"
  field :worker_grouping_key, 10, type: :string, json_name: "workerGroupingKey"
  field :process_id, 11, type: :string, json_name: "processId"
  field :plugins, 12, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo

  field :drivers, 13,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo
end
