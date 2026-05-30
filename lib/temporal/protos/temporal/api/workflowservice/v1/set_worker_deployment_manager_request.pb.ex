defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerRequest do
  @moduledoc """
  Update the ManagerIdentity of a Worker Deployment.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`conflict_token`** | `bytes` | Optional. This can be the value of conflict_token from a Describe, or another Worker |
  | 2 | **`deployment_name`** | `string` |  |
  | 6 | **`identity`** | `string` | Required. The identity of the client who initiated this request. |
  | 3 | **`manager_identity`** | `string` | Arbitrary value for `manager_identity`. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`self`** | `bool` | True will set `manager_identity` to `identity`. |

  ### Additional Notes

    * `conflict_token` (`bytes`): Optional. This can be the value of conflict_token from a Describe, or another Worker
      Deployment API. Passing a non-nil conflict token will cause this request to fail if the
      Deployment's configuration has been modified between the API call that generated the
      token and this one.
    * `manager_identity` (`string`): Arbitrary value for `manager_identity`.
      Empty will unset the field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :new_manager_identity, 0

  field :namespace, 1, type: :string
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
  field :manager_identity, 3, type: :string, json_name: "managerIdentity", oneof: 0
  field :self, 4, type: :bool, oneof: 0
  field :conflict_token, 5, type: :bytes, json_name: "conflictToken"
  field :identity, 6, type: :string
end
