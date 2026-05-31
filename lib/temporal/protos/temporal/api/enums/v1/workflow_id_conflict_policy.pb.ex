defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdConflictPolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKFLOW_ID_CONFLICT_POLICY_UNSPECIFIED, 0)
  field(:WORKFLOW_ID_CONFLICT_POLICY_FAIL, 1)
  field(:WORKFLOW_ID_CONFLICT_POLICY_USE_EXISTING, 2)
  field(:WORKFLOW_ID_CONFLICT_POLICY_TERMINATE_EXISTING, 3)
end
