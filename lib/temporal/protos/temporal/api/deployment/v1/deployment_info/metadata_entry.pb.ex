defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
end
