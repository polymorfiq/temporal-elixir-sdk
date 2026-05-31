defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedRequest.Capabilities do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:discard_speculative_workflow_task_with_events, 1,
    type: :bool,
    json_name: "discardSpeculativeWorkflowTaskWithEvents"
  )
end
