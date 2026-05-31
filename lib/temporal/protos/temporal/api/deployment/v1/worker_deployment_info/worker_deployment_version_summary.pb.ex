defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:version, 1, type: :string, deprecated: true)

  field(:status, 11,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus,
    enum: true
  )

  field(:deployment_version, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime")

  field(:drainage_status, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus,
    json_name: "drainageStatus",
    enum: true
  )

  field(:drainage_info, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo,
    json_name: "drainageInfo"
  )

  field(:current_since_time, 6, type: Google.Protobuf.Timestamp, json_name: "currentSinceTime")
  field(:ramping_since_time, 7, type: Google.Protobuf.Timestamp, json_name: "rampingSinceTime")
  field(:routing_update_time, 8, type: Google.Protobuf.Timestamp, json_name: "routingUpdateTime")

  field(:first_activation_time, 9,
    type: Google.Protobuf.Timestamp,
    json_name: "firstActivationTime"
  )

  field(:last_current_time, 12, type: Google.Protobuf.Timestamp, json_name: "lastCurrentTime")

  field(:last_deactivation_time, 10,
    type: Google.Protobuf.Timestamp,
    json_name: "lastDeactivationTime"
  )

  field(:compute_config, 13,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary,
    json_name: "computeConfig"
  )
end
