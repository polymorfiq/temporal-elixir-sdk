defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scaling_groups, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig.ScalingGroupsEntry,
    json_name: "scalingGroups",
    map: true
  )
end
