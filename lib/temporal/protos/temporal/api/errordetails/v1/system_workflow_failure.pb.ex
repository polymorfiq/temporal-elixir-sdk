defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.SystemWorkflowFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_execution, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_error, 2, type: :string, json_name: "workflowError")
end
