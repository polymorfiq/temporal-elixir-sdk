defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupSummary do
  @moduledoc """
  Automatically generated module for ComputeConfigScalingGroupSummary

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`provider_type`** | `string` |  |
  | 1 | **`task_queue_types`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue_types, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true

  field :provider_type, 2, type: :string, json_name: "providerType"
end
