defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ShutdownWorkerRequest do
  @moduledoc """
  Automatically generated module for ShutdownWorkerRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`identity`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`reason`** | `string` |  |
  | 2 | **`sticky_task_queue`** | `string` | sticky_task_queue may not always be populated. We want to ensure all workers |
  | 7 | **`task_queue`** | `string` | Task queue name the worker is polling on. This allows server to cancel |
  | 8 | **`task_queue_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | Task queue types that help server cancel outstanding poll RPC |
  | 5 | **`worker_heartbeat`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat` |  |
  | 6 | **`worker_instance_key`** | `string` | Technically this is also sent in the WorkerHeartbeat, but |

  ### Additional Notes

    * `sticky_task_queue` (`string`): sticky_task_queue may not always be populated. We want to ensure all workers
      send a shutdown request to update worker state for heartbeating, as well
      as cancel pending poll calls early, instead of waiting for timeouts.
    * `task_queue` (`string`): Task queue name the worker is polling on. This allows server to cancel
      all outstanding poll RPC calls from SDK. This avoids a race condition that
      can lead to tasks being lost.
    * `task_queue_types` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType`): Task queue types that help server cancel outstanding poll RPC
      calls from SDK. This avoids a race condition that can lead to tasks being lost.
    * `worker_instance_key` (`string`): Technically this is also sent in the WorkerHeartbeat, but
      since worker heartbeating can be turned off, this needs
      to be a separate, top-level field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :sticky_task_queue, 2, type: :string, json_name: "stickyTaskQueue"
  field :identity, 3, type: :string
  field :reason, 4, type: :string

  field :worker_heartbeat, 5,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"

  field :worker_instance_key, 6, type: :string, json_name: "workerInstanceKey"
  field :task_queue, 7, type: :string, json_name: "taskQueue"

  field :task_queue_types, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true
end
