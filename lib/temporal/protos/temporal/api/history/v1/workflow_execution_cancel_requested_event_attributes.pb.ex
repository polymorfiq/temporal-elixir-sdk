defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionCancelRequestedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cause, 1, type: :string)
  field(:external_initiated_event_id, 2, type: :int64, json_name: "externalInitiatedEventId")

  field(:external_workflow_execution, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "externalWorkflowExecution"
  )

  field(:identity, 4, type: :string)
end
