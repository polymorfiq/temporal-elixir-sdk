defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerDeploymentResponse do
  @moduledoc """
  Automatically generated module for DescribeWorkerDeploymentResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`conflict_token`** | `bytes` | This value is returned so that it can be optionally passed to APIs |
  | 2 | **`worker_deployment_info`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo` |  |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value is returned so that it can be optionally passed to APIs
      that write to the Worker Deployment state to ensure that the state
      did not change between this read and a future write.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :conflict_token, 1, type: :bytes, json_name: "conflictToken"

  field :worker_deployment_info, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo,
    json_name: "workerDeploymentInfo"
end
