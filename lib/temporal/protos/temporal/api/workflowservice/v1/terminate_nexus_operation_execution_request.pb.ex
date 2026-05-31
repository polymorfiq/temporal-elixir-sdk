defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateNexusOperationExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:operation_id, 2, type: :string, json_name: "operationId")
  field(:run_id, 3, type: :string, json_name: "runId")
  field(:identity, 4, type: :string)
  field(:request_id, 5, type: :string, json_name: "requestId")
  field(:reason, 6, type: :string)
end
