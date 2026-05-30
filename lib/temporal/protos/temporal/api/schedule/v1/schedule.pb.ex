defmodule Temporal.Protos.Temporal.Api.Schedule.V1.Schedule do
  @moduledoc """
  Automatically generated module for Schedule

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`action`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleAction` |  |
  | 3 | **`policies`** | `Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePolicies` |  |
  | 1 | **`spec`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec` |  |
  | 4 | **`state`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleState` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :spec, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec
  field :action, 2, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleAction
  field :policies, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePolicies
  field :state, 4, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleState
end
