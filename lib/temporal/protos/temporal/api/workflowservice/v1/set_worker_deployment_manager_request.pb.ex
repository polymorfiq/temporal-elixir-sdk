defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:new_manager_identity, 0)

  field(:namespace, 1, type: :string)
  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
  field(:manager_identity, 3, type: :string, json_name: "managerIdentity", oneof: 0)
  field(:self, 4, type: :bool, oneof: 0)
  field(:conflict_token, 5, type: :bytes, json_name: "conflictToken")
  field(:identity, 6, type: :string)
end
