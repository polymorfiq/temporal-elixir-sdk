defmodule Temporal.Protos.Temporal.Api.Command.V1.RequestCancelExternalWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string, deprecated: true)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:run_id, 3, type: :string, json_name: "runId")
  field(:control, 4, type: :string, deprecated: true)
  field(:child_workflow_only, 5, type: :bool, json_name: "childWorkflowOnly")
  field(:reason, 6, type: :string)
end
