defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkerVersioningRulesRequest.InsertBuildIdAssignmentRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rule_index, 1, type: :int32, json_name: "ruleIndex")
  field(:rule, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdAssignmentRule)
end
