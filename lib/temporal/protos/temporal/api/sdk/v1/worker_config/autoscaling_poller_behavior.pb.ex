defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkerConfig.AutoscalingPollerBehavior do
  @moduledoc """
  Automatically generated module for AutoscalingPollerBehavior

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`initial_pollers`** | `int32` |  |
  | 2 | **`max_pollers`** | `int32` |  |
  | 1 | **`min_pollers`** | `int32` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :min_pollers, 1, type: :int32, json_name: "minPollers"
  field :max_pollers, 2, type: :int32, json_name: "maxPollers"
  field :initial_pollers, 3, type: :int32, json_name: "initialPollers"
end
