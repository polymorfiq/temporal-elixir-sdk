defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:version, 2, type: :string, deprecated: true)

  field(:deployment_version, 5,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "deploymentVersion"
  )

  field(:upsert_entries, 3,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerDeploymentVersionMetadataRequest.UpsertEntriesEntry,
    json_name: "upsertEntries",
    map: true
  )

  field(:remove_entries, 4, repeated: true, type: :string, json_name: "removeEntries")
  field(:identity, 6, type: :string)
end
