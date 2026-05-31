defmodule Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverride do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:behavior, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverrideBehavior,
    enum: true
  )

  field(:version, 2, type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion)
end
