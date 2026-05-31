defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.SimplePollerBehavior do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:max_pollers, 1, type: :int32, json_name: "maxPollers")
end
