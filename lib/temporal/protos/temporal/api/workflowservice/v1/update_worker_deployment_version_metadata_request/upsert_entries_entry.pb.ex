defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest.UpsertEntriesEntry do
  @moduledoc """
  Used to update the user-defined metadata of a Worker Deployment Version.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` | Deprecated. Use `deployment_version`. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
