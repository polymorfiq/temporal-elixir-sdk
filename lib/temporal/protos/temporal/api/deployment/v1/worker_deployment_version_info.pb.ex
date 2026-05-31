defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:version, 1, type: :string, deprecated: true)

  field(:status, 14,
    type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerDeploymentVersionStatus,
    enum: true
  )

  field(:deployment_version, 11,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
  field(:create_time, 3, type: Google.Protobuf.Timestamp, json_name: "createTime")

  field(:routing_changed_time, 4,
    type: Google.Protobuf.Timestamp,
    json_name: "routingChangedTime"
  )

  field(:current_since_time, 5, type: Google.Protobuf.Timestamp, json_name: "currentSinceTime")
  field(:ramping_since_time, 6, type: Google.Protobuf.Timestamp, json_name: "rampingSinceTime")

  field(:first_activation_time, 12,
    type: Google.Protobuf.Timestamp,
    json_name: "firstActivationTime"
  )

  field(:last_current_time, 15, type: Google.Protobuf.Timestamp, json_name: "lastCurrentTime")

  field(:last_deactivation_time, 13,
    type: Google.Protobuf.Timestamp,
    json_name: "lastDeactivationTime"
  )

  field(:ramp_percentage, 7, type: :float, json_name: "rampPercentage")

  field(:task_queue_infos, 8,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersionInfo.VersionTaskQueueInfo,
    json_name: "taskQueueInfos"
  )

  field(:drainage_info, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo,
    json_name: "drainageInfo"
  )

  field(:metadata, 10, type: Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata)

  field(:compute_config, 16,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig,
    json_name: "computeConfig"
  )

  field(:last_modifier_identity, 17, type: :string, json_name: "lastModifierIdentity")
end
