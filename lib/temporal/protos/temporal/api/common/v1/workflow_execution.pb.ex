defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_id, 1, type: :string, json_name: "workflowId")
  field(:run_id, 2, type: :string, json_name: "runId")
end
