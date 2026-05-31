defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:requests_per_second, 1, type: :float, json_name: "requestsPerSecond")
end
