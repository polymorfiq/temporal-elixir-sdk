defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig do
  @moduledoc """
  Automatically generated module for TaskQueueConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`fairness_keys_rate_limit_default`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig` | If set, each individual fairness key will be limited to this rate, scaled by the weight of the fairness key. |
  | 3 | **`fairness_weight_overrides`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig.FairnessWeightOverridesEntry` | If set, overrides the fairness weights for the corresponding fairness keys. |
  | 1 | **`queue_rate_limit`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig` | Unless modified, this is the system-defined rate limit. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :queue_rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig,
    json_name: "queueRateLimit"

  field :fairness_keys_rate_limit_default, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig,
    json_name: "fairnessKeysRateLimitDefault"

  field :fairness_weight_overrides, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig.FairnessWeightOverridesEntry,
    json_name: "fairnessWeightOverrides",
    map: true
end
