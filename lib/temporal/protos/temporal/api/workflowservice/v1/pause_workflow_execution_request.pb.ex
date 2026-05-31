defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PauseWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:run_id, 3, type: :string, json_name: "runId")
  field(:identity, 4, type: :string)
  field(:reason, 5, type: :string)
  field(:request_id, 6, type: :string, json_name: "requestId")
end
