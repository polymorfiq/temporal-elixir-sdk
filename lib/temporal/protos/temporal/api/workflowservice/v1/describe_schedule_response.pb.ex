defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeScheduleResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:schedule, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.Schedule)
  field(:info, 2, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleInfo)
  field(:memo, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Memo)

  field(:search_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:conflict_token, 5, type: :bytes, json_name: "conflictToken")
end
