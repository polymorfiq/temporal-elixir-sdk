defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleAction do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:action, 0)

  field(:start_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo,
    json_name: "startWorkflow",
    oneof: 0
  )
end
