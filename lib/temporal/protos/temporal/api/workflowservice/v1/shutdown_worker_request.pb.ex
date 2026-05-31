defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ShutdownWorkerRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:sticky_task_queue, 2, type: :string, json_name: "stickyTaskQueue")
  field(:identity, 3, type: :string)
  field(:reason, 4, type: :string)

  field(:worker_heartbeat, 5,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"
  )

  field(:worker_instance_key, 6, type: :string, json_name: "workerInstanceKey")
  field(:task_queue, 7, type: :string, json_name: "taskQueue")

  field(:task_queue_types, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true
  )
end
