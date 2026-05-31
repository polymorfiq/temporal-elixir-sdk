defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:create_time, 1, type: Google.Protobuf.Timestamp, json_name: "createTime")
  field(:spec, 2, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec)
  field(:created_by_identity, 3, type: :string, json_name: "createdByIdentity")
  field(:description, 4, type: :string)
end
