defmodule Temporal.Protos.Temporal.Api.Schedule.V1.BackfillRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:start_time, 1, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:end_time, 2, type: Google.Protobuf.Timestamp, json_name: "endTime")

  field(:overlap_policy, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true
  )
end
