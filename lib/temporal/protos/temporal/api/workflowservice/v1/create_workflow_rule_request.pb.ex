defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateWorkflowRuleRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:spec, 2, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec)
  field(:force_scan, 3, type: :bool, json_name: "forceScan")
  field(:request_id, 4, type: :string, json_name: "requestId")
  field(:identity, 5, type: :string)
  field(:description, 6, type: :string)
end
