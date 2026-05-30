defmodule Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata do
  @moduledoc """
  Used as part of Deployment write APIs to update metadata attached to a deployment.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`remove_entries`** | `string` | List of keys to remove from the metadata. |
  | 1 | **`upsert_entries`** | `Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata.UpsertEntriesEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :upsert_entries, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata.UpsertEntriesEntry,
    json_name: "upsertEntries",
    map: true

  field :remove_entries, 2, repeated: true, type: :string, json_name: "removeEntries"
end
