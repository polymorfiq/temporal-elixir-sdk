defmodule Temporal.Protos.Temporal.Api.Enums.V1.RateLimitSource do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :RATE_LIMIT_SOURCE_UNSPECIFIED, 0
  field :RATE_LIMIT_SOURCE_API, 1
  field :RATE_LIMIT_SOURCE_WORKER, 2
  field :RATE_LIMIT_SOURCE_SYSTEM, 3
end
