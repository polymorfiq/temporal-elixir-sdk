defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:task_queue, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:poller_group_id, 10, type: :string, json_name: "pollerGroupId")
  field(:identity, 3, type: :string)
  field(:worker_instance_key, 8, type: :string, json_name: "workerInstanceKey")
  field(:worker_control_task_queue, 9, type: :string, json_name: "workerControlTaskQueue")

  field(:task_queue_metadata, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueMetadata,
    json_name: "taskQueueMetadata"
  )

  field(:worker_version_capabilities, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionCapabilities,
    json_name: "workerVersionCapabilities",
    deprecated: true
  )

  field(:deployment_options, 6,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentOptions,
    json_name: "deploymentOptions"
  )
end
