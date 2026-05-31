defmodule Temporal.Protos.Temporal.Api.Command.V1.SignalExternalWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string, deprecated: true)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:signal_name, 3, type: :string, json_name: "signalName")
  field(:input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:control, 5, type: :string, deprecated: true)
  field(:child_workflow_only, 6, type: :bool, json_name: "childWorkflowOnly")
  field(:header, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
end
