defmodule Temporal.Protos.Temporal.Api.Export.V1.WorkflowExecution do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:history, 1, type: Temporal.Protos.Temporal.Api.History.V1.History)
end
