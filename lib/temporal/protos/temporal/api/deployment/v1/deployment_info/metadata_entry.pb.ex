defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry do
  @moduledoc """
  `DeploymentInfo` holds information about a deployment. Deployment information is tracked
  automatically by server as soon as the first poll from that deployment reaches the server. There
  can be multiple task queue workers in a single deployment which are listed in this message.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
