defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit,
    json_name: "rateLimit"
  )

  field(:metadata, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.ConfigMetadata)
end
