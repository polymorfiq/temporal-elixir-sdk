defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest do
  @moduledoc """
  Automatically generated module for UpdateTaskQueueConfigRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |
  | 7 | **`set_fairness_weight_overrides`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.SetFairnessWeightOverridesEntry` | If set, overrides the fairness weight for each specified fairness key. |
  | 3 | **`task_queue`** | `string` | Selects the task queue to update. |
  | 4 | **`task_queue_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` |  |
  | 8 | **`unset_fairness_weight_overrides`** | `string` | If set, removes any existing fairness weight overrides for each specified fairness key. |
  | 6 | **`update_fairness_key_rate_limit_default`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate` | Update to the default fairness key rate limit. |
  | 5 | **`update_queue_rate_limit`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate` | Update to queue-wide rate limit. |

  ### Additional Notes

    * `set_fairness_weight_overrides` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.SetFairnessWeightOverridesEntry`): If set, overrides the fairness weight for each specified fairness key.
      Fairness keys not listed in this map will keep their existing overrides (if any).
    * `unset_fairness_weight_overrides` (`string`): If set, removes any existing fairness weight overrides for each specified fairness key.
      Fairness weights for corresponding keys fall back to the values set during task creation (if any),
      or to the default weight of 1.0.
    * `update_fairness_key_rate_limit_default` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate`): Update to the default fairness key rate limit.
      If not set, this configuration is unchanged.
      If the `rate_limit` field in the `RateLimitUpdate` is missing, remove the existing rate limit.
    * `update_queue_rate_limit` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate`): Update to queue-wide rate limit.
      If not set, this configuration is unchanged.
      NOTE: A limit set by the worker is overriden; and restored again when reset.
      If the `rate_limit` field in the `RateLimitUpdate` is missing, remove the existing rate limit.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string
  field :task_queue, 3, type: :string, json_name: "taskQueue"

  field :task_queue_type, 4,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueType",
    enum: true

  field :update_queue_rate_limit, 5,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate,
    json_name: "updateQueueRateLimit"

  field :update_fairness_key_rate_limit_default, 6,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.RateLimitUpdate,
    json_name: "updateFairnessKeyRateLimitDefault"

  field :set_fairness_weight_overrides, 7,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigRequest.SetFairnessWeightOverridesEntry,
    json_name: "setFairnessWeightOverrides",
    map: true

  field :unset_fairness_weight_overrides, 8,
    repeated: true,
    type: :string,
    json_name: "unsetFairnessWeightOverrides"
end
