defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:version, 2, type: :string, deprecated: true)

  field(:deployment_version, 3,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:report_task_queue_stats, 4, type: :bool, json_name: "reportTaskQueueStats")
end
