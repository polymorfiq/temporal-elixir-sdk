defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 3, type: :string)
  field(:namespace, 4, type: :string)
  field(:resource_id, 5, type: :string, json_name: "resourceId")
end
