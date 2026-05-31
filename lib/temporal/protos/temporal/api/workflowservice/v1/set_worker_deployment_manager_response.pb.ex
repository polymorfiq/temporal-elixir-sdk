defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentManagerResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:conflict_token, 1, type: :bytes, json_name: "conflictToken")

  field(:previous_manager_identity, 2,
    type: :string,
    json_name: "previousManagerIdentity",
    deprecated: true
  )
end
