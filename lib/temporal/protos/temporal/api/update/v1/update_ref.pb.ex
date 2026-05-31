defmodule Temporal.Protos.Temporal.Api.Update.V1.UpdateRef do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_execution, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:update_id, 2, type: :string, json_name: "updateId")
end
