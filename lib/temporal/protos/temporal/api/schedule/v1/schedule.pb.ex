defmodule Temporal.Protos.Temporal.Api.Schedule.V1.Schedule do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:spec, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec)
  field(:action, 2, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleAction)
  field(:policies, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePolicies)
  field(:state, 4, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleState)
end
