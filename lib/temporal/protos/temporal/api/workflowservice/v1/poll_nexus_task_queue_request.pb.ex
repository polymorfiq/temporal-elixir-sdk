defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:task_queue, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:poller_group_id, 9, type: :string, json_name: "pollerGroupId")
  field(:identity, 2, type: :string)
  field(:worker_instance_key, 8, type: :string, json_name: "workerInstanceKey")

  field(:worker_version_capabilities, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities,
    json_name: "workerVersionCapabilities",
    deprecated: true
  )

  field(:deployment_options, 6,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )

  field(:worker_heartbeat, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerHeartbeat,
    json_name: "workerHeartbeat"
  )
end
