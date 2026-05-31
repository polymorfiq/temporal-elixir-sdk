defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetWorkflowExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:reason, 3, type: :string)
  field(:workflow_task_finish_event_id, 4, type: :int64, json_name: "workflowTaskFinishEventId")
  field(:request_id, 5, type: :string, json_name: "requestId")

  field(:reset_reapply_type, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyType,
    json_name: "resetReapplyType",
    enum: true,
    deprecated: true
  )

  field(:reset_reapply_exclude_types, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ResetReapplyExcludeType,
    json_name: "resetReapplyExcludeTypes",
    enum: true
  )

  field(:post_reset_operations, 8,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation,
    json_name: "postResetOperations"
  )

  field(:identity, 9, type: :string)
end
