defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerPollerInfo do
  @moduledoc """
  Automatically generated module for WorkerPollerInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`current_pollers`** | `int32` | Number of polling RPCs that are currently in flight. |
  | 3 | **`is_autoscaling`** | `bool` | Set true if the number of concurrent pollers is auto-scaled |
  | 2 | **`last_successful_poll_time`** | `Google.Protobuf.Timestamp` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :current_pollers, 1, type: :int32, json_name: "currentPollers"

  field :last_successful_poll_time, 2,
    type: Google.Protobuf.Timestamp,
    json_name: "lastSuccessfulPollTime"

  field :is_autoscaling, 3, type: :bool, json_name: "isAutoscaling"
end
