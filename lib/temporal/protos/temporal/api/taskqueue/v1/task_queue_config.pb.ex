defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:queue_rate_limit, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig,
    json_name: "queueRateLimit"
  )

  field(:fairness_keys_rate_limit_default, 2,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.RateLimitConfig,
    json_name: "fairnessKeysRateLimitDefault"
  )

  field(:fairness_weight_overrides, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig.FairnessWeightOverridesEntry,
    json_name: "fairnessWeightOverrides",
    map: true
  )
end
