defmodule Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfig.ScalingGroupsEntry do
  @moduledoc """
  ComputeConfig stores configuration that helps a worker control plane
  controller understand *when* and *how* to respond to worker lifecycle
  events.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Each scaling group describes a compute config for a specific subset of the worker |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup` |  |

  ### Additional Notes

    * `key` (`string`): Each scaling group describes a compute config for a specific subset of the worker
      deployment version: covering a specific set of task types and/or regions.
      Having different configurations for different task types, allows independent
      tuning of activity and workflow task processing (for example).

      The key of the map is the ID of the scaling group used to reference it in subsequent
      update calls.

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Compute.V1.ComputeConfigScalingGroup
end
