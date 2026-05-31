defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:schedule_id, 2, type: :string, json_name: "scheduleId")
  field(:start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:end_time, 4, type: Google.Protobuf.Timestamp, json_name: "endTime")
end
