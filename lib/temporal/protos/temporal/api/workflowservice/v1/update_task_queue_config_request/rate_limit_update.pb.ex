defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate do
  @moduledoc """
  Automatically generated module for RateLimitUpdate

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`rate_limit`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit` |  |
  | 2 | **`reason`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimit,
    json_name: "rateLimit"

  field :reason, 2, type: :string
end
