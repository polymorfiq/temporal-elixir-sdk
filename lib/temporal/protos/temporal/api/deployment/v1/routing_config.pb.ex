defmodule Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current_deployment_version, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "currentDeploymentVersion"
  )

  field(:current_version, 1, type: :string, json_name: "currentVersion", deprecated: true)

  field(:ramping_deployment_version, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "rampingDeploymentVersion"
  )

  field(:ramping_version, 2, type: :string, json_name: "rampingVersion", deprecated: true)
  field(:ramping_version_percentage, 3, type: :float, json_name: "rampingVersionPercentage")

  field(:current_version_changed_time, 4,
    type: Google.Protobuf.Timestamp,
    json_name: "currentVersionChangedTime"
  )

  field(:ramping_version_changed_time, 5,
    type: Google.Protobuf.Timestamp,
    json_name: "rampingVersionChangedTime"
  )

  field(:ramping_version_percentage_changed_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "rampingVersionPercentageChangedTime"
  )

  field(:revision_number, 10, type: :int64, json_name: "revisionNumber")
end
