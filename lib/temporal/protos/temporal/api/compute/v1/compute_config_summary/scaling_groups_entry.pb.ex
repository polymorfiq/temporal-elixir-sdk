defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary.ScalingGroupsEntry do
  @moduledoc """
  A subset of information in ComputeConfig optimized for list views.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupSummary` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupSummary
end
