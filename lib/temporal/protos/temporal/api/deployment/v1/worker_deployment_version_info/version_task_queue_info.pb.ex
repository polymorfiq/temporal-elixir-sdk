defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:type, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType, enum: true)
end
