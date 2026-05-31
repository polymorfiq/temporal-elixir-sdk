defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:structured_calendar, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec,
    json_name: "structuredCalendar"
  )

  field(:cron_string, 8, repeated: true, type: :string, json_name: "cronString")
  field(:calendar, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec)
  field(:interval, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.IntervalSpec)

  field(:exclude_calendar, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec,
    json_name: "excludeCalendar",
    deprecated: true
  )

  field(:exclude_structured_calendar, 9,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec,
    json_name: "excludeStructuredCalendar"
  )

  field(:start_time, 4, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:end_time, 5, type: Google.Protobuf.Timestamp, json_name: "endTime")
  field(:jitter, 6, type: Google.Protobuf.Duration)
  field(:timezone_name, 10, type: :string, json_name: "timezoneName")
  field(:timezone_data, 11, type: :bytes, json_name: "timezoneData")
end
