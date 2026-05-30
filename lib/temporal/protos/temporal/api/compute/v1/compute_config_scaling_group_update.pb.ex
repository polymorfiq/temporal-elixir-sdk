defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroupUpdate do
  @moduledoc """
  Automatically generated module for ComputeConfigScalingGroupUpdate

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`scaling_group`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup` |  |
  | 2 | **`update_mask`** | `Google.Protobuf.FieldMask` | Controls which fields from `scaling_group` will be applied. Semantics: |

  ### Additional Notes

    * `update_mask` (`Google.Protobuf.FieldMask`): Controls which fields from `scaling_group` will be applied. Semantics:
      - Mask is ignored for new scaling groups (only applicable when scaling group already exists).
      - Empty mask for an existing scaling group is no-op: no change.
      - Non-empty mask for an existing scaling group will update/unset only to the fields
        mentioned in the mask.
      - Accepted paths: "task_queue_types", "provider", "provider.type", "provider.details",
        "provider.nexus_endpoint", "scaler", "scaler.type", "scaler.details"

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scaling_group, 1,
    type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup,
    json_name: "scalingGroup"

  field :update_mask, 2, type: Google.Protobuf.FieldMask, json_name: "updateMask"
end
