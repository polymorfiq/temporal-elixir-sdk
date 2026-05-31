defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:start_time, 1, repeated: true, type: Google.Protobuf.Timestamp, json_name: "startTime")
end
