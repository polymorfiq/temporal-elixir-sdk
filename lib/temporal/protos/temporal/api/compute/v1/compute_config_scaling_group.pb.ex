defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup do
  @moduledoc """
  Automatically generated module for ComputeConfigScalingGroup

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`provider`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider` | Stores instructions for a worker control plane controller how to respond |
  | 4 | **`scaler`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler` | Informs a worker lifecycle controller *when* and *how often* to perform |
  | 1 | **`task_queue_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` | Optional. The set of task queue types this scaling group serves. |

  ### Additional Notes

    * `provider` (`Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider`): Stores instructions for a worker control plane controller how to respond
      to worker lifeycle events.
    * `scaler` (`Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler`): Informs a worker lifecycle controller *when* and *how often* to perform
      certain worker lifecycle actions like starting a serverless worker.
    * `task_queue_types` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType`): Optional. The set of task queue types this scaling group serves.
      If not provided, this scaling group serves all not otherwise defined
      task types.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue_types, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true

  field :provider, 3, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider
  field :scaler, 4, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler
end
