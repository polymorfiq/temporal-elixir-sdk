defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:key, 1, type: :string)
  field(:value, 2, type: Temporal.Protos.Temporal.Api.Workflow.V1.RequestIdInfo)
end
