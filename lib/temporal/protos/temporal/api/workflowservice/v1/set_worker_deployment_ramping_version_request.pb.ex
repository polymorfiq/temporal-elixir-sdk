defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentRampingVersionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
  field(:version, 3, type: :string, deprecated: true)
  field(:build_id, 8, type: :string, json_name: "buildId")
  field(:percentage, 4, type: :float)
  field(:conflict_token, 5, type: :bytes, json_name: "conflictToken")
  field(:identity, 6, type: :string)
  field(:ignore_missing_task_queues, 7, type: :bool, json_name: "ignoreMissingTaskQueues")
  field(:allow_no_pollers, 10, type: :bool, json_name: "allowNoPollers")
end
