defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.RampByPercentage do
  @moduledoc """
  Automatically generated module for RampByPercentage

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`ramp_percentage`** | `float` | Acceptable range is [0,100). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :ramp_percentage, 1, type: :float, json_name: "rampPercentage"
end
