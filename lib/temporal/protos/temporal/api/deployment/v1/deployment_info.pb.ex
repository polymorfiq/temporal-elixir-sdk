defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:deployment, 1, type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment)
  field(:create_time, 2, type: Google.Protobuf.Timestamp, json_name: "createTime")

  field(:task_queue_infos, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.TaskQueueInfo,
    json_name: "taskQueueInfos"
  )

  field(:metadata, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.MetadataEntry,
    map: true
  )

  field(:is_current, 5, type: :bool, json_name: "isCurrent")
end
