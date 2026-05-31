defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkflowIdReusePolicy do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:WORKFLOW_ID_REUSE_POLICY_UNSPECIFIED, 0)
  field(:WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE, 1)
  field(:WORKFLOW_ID_REUSE_POLICY_ALLOW_DUPLICATE_FAILED_ONLY, 2)
  field(:WORKFLOW_ID_REUSE_POLICY_REJECT_DUPLICATE, 3)
  field(:WORKFLOW_ID_REUSE_POLICY_TERMINATE_IF_RUNNING, 4)
end
