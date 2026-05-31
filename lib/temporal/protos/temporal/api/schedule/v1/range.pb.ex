defmodule Temporal.Protos.Temporal.Api.Schedule.V1.Range do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:start, 1, type: :int32)
  field(:end, 2, type: :int32)
  field(:step, 3, type: :int32)
end
