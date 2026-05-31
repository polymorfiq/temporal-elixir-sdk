defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupUpdate do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scaling_group, 1,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup,
    json_name: "scalingGroup"
  )

  field(:update_mask, 2, type: Google.Protobuf.FieldMask, json_name: "updateMask")
end
