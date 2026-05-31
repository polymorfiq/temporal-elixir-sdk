defmodule Temporal.Protos.Temporal.Api.History.V1.History do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:events, 1, repeated: true, type: Temporal.Protos.Temporal.Api.History.V1.HistoryEvent)
end
