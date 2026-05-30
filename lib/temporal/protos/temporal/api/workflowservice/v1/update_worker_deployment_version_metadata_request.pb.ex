defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest do
  @moduledoc """
  Used to update the user-defined metadata of a Worker Deployment Version.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Required. |
  | 6 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`remove_entries`** | `string` | List of keys to remove from the metadata. |
  | 3 | **`upsert_entries`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest.UpsertEntriesEntry` |  |
  | 2 | **`version`** | `string` | Deprecated. Use `deployment_version`. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :version, 2, type: :string, deprecated: true

  field :deployment_version, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"

  field :upsert_entries, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest.UpsertEntriesEntry,
    json_name: "upsertEntries",
    map: true

  field :remove_entries, 4, repeated: true, type: :string, json_name: "removeEntries"
  field :identity, 6, type: :string
end
