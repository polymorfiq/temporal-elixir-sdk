defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PatchScheduleRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:schedule_id, 2, type: :string, json_name: "scheduleId")
  field(:patch, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch)
  field(:identity, 4, type: :string)
  field(:request_id, 5, type: :string, json_name: "requestId")
end
