defmodule Temporal.Protos.Temporal.Api.Schedule.V1.TriggerImmediatelyRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:overlap_policy, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true
  )

  field(:scheduled_time, 2, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")
end
