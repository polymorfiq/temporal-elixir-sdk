defmodule Temporal.Protos.Temporal.Api.Common.V1.ResetOptions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:target, 0)

  field(:first_workflow_task, 1,
    type: Google.Protobuf.Empty,
    json_name: "firstWorkflowTask",
    oneof: 0
  )

  field(:last_workflow_task, 2,
    type: Google.Protobuf.Empty,
    json_name: "lastWorkflowTask",
    oneof: 0
  )

  field(:workflow_task_id, 3, type: :int64, json_name: "workflowTaskId", oneof: 0)
  field(:build_id, 4, type: :string, json_name: "buildId", oneof: 0)

  field(:reset_reapply_type, 10,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true
  )

  field(:current_run_only, 11, type: :bool, json_name: "currentRunOnly")

  field(:reset_reapply_exclude_types, 12,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType,
    json_name: "resetReapplyExcludeTypes",
    enum: true
  )
end
