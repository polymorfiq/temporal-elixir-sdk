defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary do
  @moduledoc """
  A subset of information in ComputeConfig optimized for list views.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scaling_groups`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary.ScalingGroupsEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scaling_groups, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigSummary.ScalingGroupsEntry,
    json_name: "scalingGroups",
    map: true
end
