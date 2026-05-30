defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataResponse do
  @moduledoc """
  Automatically generated module for UpdateWorkerDeploymentVersionMetadataResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`metadata`** | `Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata` | Full metadata after performing the update. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :metadata, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata
end
