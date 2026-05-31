defmodule Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_state, 1, type: :string, json_name: "operationState")
  field(:failure, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure)
end
