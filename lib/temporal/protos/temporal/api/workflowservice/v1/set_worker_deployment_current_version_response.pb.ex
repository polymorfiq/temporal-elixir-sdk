defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionResponse do
  @moduledoc """
  Automatically generated module for SetWorkerDeploymentCurrentVersionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`conflict_token`** | `bytes` | This value is returned so that it can be optionally passed to APIs |
  | 3 | **`previous_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | The version that was current before executing this operation. |
  | 2 | **`previous_version`** | `string` | Deprecated. Use `previous_deployment_version`. |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value is returned so that it can be optionally passed to APIs
      that write to the Worker Deployment state to ensure that the state
      did not change between this API call and a future write.
    * `previous_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): The version that was current before executing this operation.
      Deprecated in favor of idempotency of the API. Use `DescribeWorkerDeployment` to get the
      Current version info before calling this API. By passing the `conflict_token` got from the
      `DescribeWorkerDeployment` call to this API you can ensure there is no interfering changes
      between the two calls.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :conflict_token, 1, type: :bytes, json_name: "conflictToken"
  field :previous_version, 2, type: :string, json_name: "previousVersion", deprecated: true

  field :previous_deployment_version, 3,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "previousDeploymentVersion",
    deprecated: true
end
