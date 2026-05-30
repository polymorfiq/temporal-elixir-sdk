defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig do
  @moduledoc """
  Automatically generated module for RateLimitConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`metadata`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.ConfigMetadata` |  |
  | 1 | **`rate_limit`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit,
    json_name: "rateLimit"

  field :metadata, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.ConfigMetadata
end
