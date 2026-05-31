defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupSummary do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_queue_types, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true
  )

  field(:provider_type, 2, type: :string, json_name: "providerType")
end
