defmodule Temporal.Protos.Temporal.Api.Command.V1.CancelWorkflowExecutionCommandAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
end
