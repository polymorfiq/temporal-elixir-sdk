defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondActivityTaskCompletedByIdRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:run_id, 3, type: :string, json_name: "runId")
  field(:activity_id, 4, type: :string, json_name: "activityId")
  field(:result, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 6, type: :string)
  field(:resource_id, 7, type: :string, json_name: "resourceId")
end
