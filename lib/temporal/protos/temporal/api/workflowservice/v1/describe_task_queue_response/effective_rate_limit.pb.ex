defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeTaskQueueResponse.EffectiveRateLimit do
  @moduledoc """
  Automatically generated module for EffectiveRateLimit

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`rate_limit_source`** | `Temporal.Protos.Temporal.Api.Enums.V1.RateLimitSource` | Statistics for the task queue. |
  | 1 | **`requests_per_second`** | `float` |  |

  ### Additional Notes

    * `rate_limit_source` (`Temporal.Protos.Temporal.Api.Enums.V1.RateLimitSource`): Statistics for the task queue.
      Only set if `report_stats` is set on the request.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :requests_per_second, 1, type: :float, json_name: "requestsPerSecond"

  field :rate_limit_source, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RateLimitSource,
    json_name: "rateLimitSource",
    enum: true
end
