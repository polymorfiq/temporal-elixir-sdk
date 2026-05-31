defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionTerminatedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:reason, 1, type: :string)
  field(:details, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 3, type: :string)
end
