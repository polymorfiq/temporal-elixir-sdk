defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig.FairnessWeightOverridesEntry do
  @moduledoc """
  Automatically generated module for FairnessWeightOverridesEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Unless modified, this is the system-defined rate limit. |
  | 2 | **`value`** | `float` | If set, each individual fairness key will be limited to this rate, scaled by the weight of the fairness key. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :float
end
