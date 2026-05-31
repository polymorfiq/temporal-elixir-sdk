defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionVersioningInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:behavior, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior, enum: true)

  field(:deployment, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:version, 5, type: :string, deprecated: true)

  field(:deployment_version, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:versioning_override, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride,
    json_name: "versioningOverride"
  )

  field(:deployment_transition, 4,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentTransition,
    json_name: "deploymentTransition",
    deprecated: true
  )

  field(:version_transition, 6,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.DeploymentVersionTransition,
    json_name: "versionTransition"
  )

  field(:revision_number, 8, type: :int64, json_name: "revisionNumber")

  field(:continue_as_new_initial_versioning_behavior, 9,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ContinueAsNewVersioningBehavior,
    json_name: "continueAsNewInitialVersioningBehavior",
    enum: true
  )
end
