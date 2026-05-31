defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:deployment_name, 2, type: :string, json_name: "deploymentName")
  field(:version, 3, type: :string, deprecated: true)
  field(:build_id, 7, type: :string, json_name: "buildId")
  field(:conflict_token, 4, type: :bytes, json_name: "conflictToken")
  field(:identity, 5, type: :string)
  field(:ignore_missing_task_queues, 6, type: :bool, json_name: "ignoreMissingTaskQueues")
  field(:allow_no_pollers, 9, type: :bool, json_name: "allowNoPollers")
end
