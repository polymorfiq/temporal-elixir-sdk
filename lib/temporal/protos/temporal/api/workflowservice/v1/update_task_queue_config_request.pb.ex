defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:task_queue, 3, type: :string, json_name: "taskQueue")

  field(:task_queue_type, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueType",
    enum: true
  )

  field(:update_queue_rate_limit, 5,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate,
    json_name: "updateQueueRateLimit"
  )

  field(:update_fairness_key_rate_limit_default, 6,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate,
    json_name: "updateFairnessKeyRateLimitDefault"
  )

  field(:set_fairness_weight_overrides, 7,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.SetFairnessWeightOverridesEntry,
    json_name: "setFairnessWeightOverrides",
    map: true
  )

  field(:unset_fairness_weight_overrides, 8,
    repeated: true,
    type: :string,
    json_name: "unsetFairnessWeightOverrides"
  )
end
