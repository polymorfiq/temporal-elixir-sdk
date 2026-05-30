defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetCurrentDeploymentRequest do
  @moduledoc """
  [cleanup-wv-pre-release] Pre-release deployment APIs, clean up later

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`deployment`** | `Temporal.Protos.Temporal.Api.Deployment.V1.Deployment` |  |
  | 3 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`update_metadata`** | `Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata` | Optional. Use to add or remove user-defined metadata entries. Metadata entries are exposed |

  ### Additional Notes

    * `update_metadata` (`Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata`): Optional. Use to add or remove user-defined metadata entries. Metadata entries are exposed
      when describing a deployment. It is a good place for information such as operator name,
      links to internal deployment pipelines, etc.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment
  field :identity, 3, type: :string

  field :update_metadata, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata,
    json_name: "updateMetadata"
end
