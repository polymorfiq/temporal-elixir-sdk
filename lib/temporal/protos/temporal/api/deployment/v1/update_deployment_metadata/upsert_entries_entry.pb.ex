defmodule Temporal.Protos.Temporal.Api.Deployment.V1.UpdateDeploymentMetadata.UpsertEntriesEntry do
  @moduledoc """
  Used as part of Deployment write APIs to update metadata attached to a deployment.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | List of keys to remove from the metadata. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
