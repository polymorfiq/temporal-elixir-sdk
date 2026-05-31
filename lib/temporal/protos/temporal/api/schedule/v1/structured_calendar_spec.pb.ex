defmodule Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:second, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range)
  field(:minute, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range)
  field(:hour, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range)

  field(:day_of_month, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.Range,
    json_name: "dayOfMonth"
  )

  field(:month, 5, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range)
  field(:year, 6, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range)

  field(:day_of_week, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.Range,
    json_name: "dayOfWeek"
  )

  field(:comment, 8, type: :string)
end
