defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.QueryWorkflowRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:query, 3, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery)

  field(:query_reject_condition, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.QueryRejectCondition,
    json_name: "queryRejectCondition",
    enum: true
  )
end
