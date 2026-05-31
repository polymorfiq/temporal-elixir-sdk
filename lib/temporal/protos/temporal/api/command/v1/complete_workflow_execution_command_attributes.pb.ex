defmodule Temporal.Protos.Temporal.Api.Command.V1.CompleteWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
end
