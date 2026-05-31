defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerListInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:worker_instance_key, 1, type: :string, json_name: "workerInstanceKey")
  field(:worker_identity, 2, type: :string, json_name: "workerIdentity")
  field(:task_queue, 3, type: :string, json_name: "taskQueue")

  field(:deployment_version, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:sdk_name, 5, type: :string, json_name: "sdkName")
  field(:sdk_version, 6, type: :string, json_name: "sdkVersion")
  field(:status, 7, type: Temporal.Protos.Temporal.Api.Enums.V1.WorkerStatus, enum: true)
  field(:start_time, 8, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:host_name, 9, type: :string, json_name: "hostName")
  field(:worker_grouping_key, 10, type: :string, json_name: "workerGroupingKey")
  field(:process_id, 11, type: :string, json_name: "processId")
  field(:plugins, 12, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo)

  field(:drivers, 13,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo
  )
end
