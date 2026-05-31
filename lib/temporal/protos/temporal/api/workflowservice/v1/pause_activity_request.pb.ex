defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseActivityRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:identity, 3, type: :string)
  field(:id, 4, type: :string, oneof: 0)
  field(:type, 5, type: :string, oneof: 0)
  field(:reason, 6, type: :string)
  field(:request_id, 7, type: :string, json_name: "requestId")
end
