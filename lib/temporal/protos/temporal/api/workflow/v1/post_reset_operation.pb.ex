defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:signal_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.SignalWorkflow,
    json_name: "signalWorkflow",
    oneof: 0
  )

  field(:update_workflow_options, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PostResetOperation.UpdateWorkflowOptions,
    json_name: "updateWorkflowOptions",
    oneof: 0
  )
end
