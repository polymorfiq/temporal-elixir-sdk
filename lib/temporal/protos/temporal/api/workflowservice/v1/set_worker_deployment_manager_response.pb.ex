defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerResponse do
  @moduledoc """
  Automatically generated module for SetWorkerDeploymentManagerResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`conflict_token`** | `bytes` | This value is returned so that it can be optionally passed to APIs |
  | 2 | **`previous_manager_identity`** | `string` | What the `manager_identity` field was before this change. |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value is returned so that it can be optionally passed to APIs
      that write to the Worker Deployment state to ensure that the state
      did not change between this API call and a future write.
    * `previous_manager_identity` (`string`): What the `manager_identity` field was before this change.
      Deprecated in favor of idempotency of the API. Use `DescribeWorkerDeployment` to get the
      manager identity before calling this API. By passing the `conflict_token` got from the
      `DescribeWorkerDeployment` call to this API you can ensure there is no interfering changes
      between the two calls.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :conflict_token, 1, type: :bytes, json_name: "conflictToken"

  field :previous_manager_identity, 2,
    type: :string,
    json_name: "previousManagerIdentity",
    deprecated: true
end
