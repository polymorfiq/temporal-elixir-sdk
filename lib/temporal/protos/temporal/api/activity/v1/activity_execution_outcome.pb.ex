defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:value, 0)

  field(:result, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads, oneof: 0)
  field(:failure, 2, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0)
end
