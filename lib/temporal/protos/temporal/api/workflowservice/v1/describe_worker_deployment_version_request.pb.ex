defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentVersionRequest do
  @moduledoc """
  Automatically generated module for DescribeWorkerDeploymentVersionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`report_task_queue_stats`** | `bool` | Report stats for task queues which have been polled by this version. |
  | 2 | **`version`** | `string` | Deprecated. Use `deployment_version`. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :version, 2, type: :string, deprecated: true

  field :deployment_version, 3,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :report_task_queue_stats, 4, type: :bool, json_name: "reportTaskQueueStats"
end
