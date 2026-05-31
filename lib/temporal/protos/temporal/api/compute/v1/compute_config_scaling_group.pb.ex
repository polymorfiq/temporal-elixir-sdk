defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_queue_types, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType,
    json_name: "taskQueueTypes",
    enum: true
  )

  field(:provider, 3, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeProvider)
  field(:scaler, 4, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeScaler)
end
