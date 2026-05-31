defmodule Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)

  field(:version_summaries, 2,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentInfo.WorkerDeploymentVersionSummary,
    json_name: "versionSummaries"
  )

  field(:create_time, 3, type: Google.Protobuf.Timestamp, json_name: "createTime")

  field(:routing_config, 4,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig,
    json_name: "routingConfig"
  )

  field(:last_modifier_identity, 5, type: :string, json_name: "lastModifierIdentity")
  field(:manager_identity, 6, type: :string, json_name: "managerIdentity")

  field(:routing_config_update_state, 7,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RoutingConfigUpdateState,
    json_name: "routingConfigUpdateState",
    enum: true
  )
end
