defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:activity_id, 3, type: :string, json_name: "activityId")
  field(:run_id, 4, type: :string, json_name: "runId")
  field(:identity, 5, type: :string)
  field(:reason, 6, type: :string)
  field(:resource_id, 7, type: :string, json_name: "resourceId")
  field(:request_id, 8, type: :string, json_name: "requestId")
end
