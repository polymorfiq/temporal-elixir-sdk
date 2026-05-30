defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueRequest do
  @moduledoc """
  Automatically generated module for PollNexusTaskQueueRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`deployment_options`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions` | Worker deployment options that user has set in the worker. |
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 9 | **`poller_group_id`** | `string` | Unless this is the first poll, the client must pass one of the poller group IDs received in |
  | 3 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 7 | **`worker_heartbeat`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat` | Worker info to be sent to the server. |
  | 8 | **`worker_instance_key`** | `string` | A unique key for this worker instance, used for tracking worker lifecycle. |
  | 4 | **`worker_version_capabilities`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities` | Information about this worker's build identifier and if it is choosing to use the versioning |

  ### Additional Notes

    * `poller_group_id` (`string`): Unless this is the first poll, the client must pass one of the poller group IDs received in
      `poller_group_infos` of the last the PollNexusTaskQueueResponse according to the
      instructions. If not set, the poll is routed randomly which can cause it to be blocked
      without receiving a task while the queue actually has tasks in another server location.
    * `worker_instance_key` (`string`): A unique key for this worker instance, used for tracking worker lifecycle.
      This is guaranteed to be unique, whereas identity is not guaranteed to be unique.
    * `worker_version_capabilities` (`Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities`): Information about this worker's build identifier and if it is choosing to use the versioning
      feature. See the `WorkerVersionCapabilities` docstring for more.
      Deprecated. Replaced by deployment_options.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :poller_group_id, 9, type: :string, json_name: "pollerGroupId"
  field :identity, 2, type: :string
  field :worker_instance_key, 8, type: :string, json_name: "workerInstanceKey"

  field :worker_version_capabilities, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities,
    json_name: "workerVersionCapabilities",
    deprecated: true

  field :deployment_options, 6,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"

  field :worker_heartbeat, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"
end
