defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.AutoscalingPollerBehavior do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:min_pollers, 1, type: :int32, json_name: "minPollers")
  field(:max_pollers, 2, type: :int32, json_name: "maxPollers")
  field(:initial_pollers, 3, type: :int32, json_name: "initialPollers")
end
