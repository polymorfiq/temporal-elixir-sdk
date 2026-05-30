defmodule Temporal.Protos.Temporal.Api.Enums.V1.PendingWorkflowTaskState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :PENDING_WORKFLOW_TASK_STATE_UNSPECIFIED, 0
  field :PENDING_WORKFLOW_TASK_STATE_SCHEDULED, 1
  field :PENDING_WORKFLOW_TASK_STATE_STARTED, 2
end
