defmodule Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecutions do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:items, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecution)
end
