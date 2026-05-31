defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateScheduleRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:schedule_id, 2, type: :string, json_name: "scheduleId")
  field(:schedule, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.Schedule)

  field(:initial_patch, 4,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch,
    json_name: "initialPatch"
  )

  field(:identity, 5, type: :string)
  field(:request_id, 6, type: :string, json_name: "requestId")
  field(:memo, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )
end
