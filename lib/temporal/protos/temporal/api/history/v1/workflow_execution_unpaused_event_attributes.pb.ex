defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionUnpausedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:identity, 1, type: :string)
  field(:reason, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
end
