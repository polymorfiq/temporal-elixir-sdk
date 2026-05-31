defmodule Temporal.Protos.Temporal.Api.Schedule.V1.IntervalSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:interval, 1, type: Google.Protobuf.Duration)
  field(:phase, 2, type: Google.Protobuf.Duration)
end
