defmodule Temporal.Protos.Temporal.Api.Deployment.V1.InheritedAutoUpgradeInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:source_deployment_version, 1,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "sourceDeploymentVersion"
  )

  field(:source_deployment_revision_number, 2,
    type: :int64,
    json_name: "sourceDeploymentRevisionNumber"
  )

  field(:continue_as_new_initial_versioning_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "continueAsNewInitialVersioningBehavior",
    enum: true
  )
end
