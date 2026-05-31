defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKER_DEPLOYMENT_VERSION_STATUS_UNSPECIFIED, 0)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_INACTIVE, 1)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_CURRENT, 2)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_RAMPING, 3)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_DRAINING, 4)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_DRAINED, 5)
  field(:WORKER_DEPLOYMENT_VERSION_STATUS_CREATED, 6)
end
