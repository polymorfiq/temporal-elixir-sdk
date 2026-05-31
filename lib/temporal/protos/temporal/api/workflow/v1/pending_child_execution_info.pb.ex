defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingChildExecutionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_id, 1, type: :string, json_name: "workflowId")
  field(:run_id, 2, type: :string, json_name: "runId")
  field(:workflow_type_name, 3, type: :string, json_name: "workflowTypeName")
  field(:initiated_id, 4, type: :int64, json_name: "initiatedId")

  field(:parent_close_policy, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ParentClosePolicy,
    json_name: "parentClosePolicy",
    enum: true
  )
end
