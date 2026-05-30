defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleSpec do
  @moduledoc """
  ScheduleSpec is a complete description of a set of absolute timestamps
  (possibly infinite) that an action should occur at. The meaning of a
  ScheduleSpec depends only on its contents and never changes, except that the
  definition of a time zone can change over time (most commonly, when daylight
  saving time policy changes for an area). To create a totally self-contained
  ScheduleSpec, use UTC or include timezone_data.

  For input, you can provide zero or more of: structured_calendar, calendar,
  cron_string, interval, and exclude_structured_calendar, and all of them will
  be used (the schedule will take action at the union of all of their times,
  minus the ones that match exclude_structured_calendar).

  On input, calendar and cron_string fields will be compiled into
  structured_calendar (and maybe interval and timezone_name), so if you
  Describe a schedule, you'll see only structured_calendar, interval, etc.

  If a spec has no matching times after the current time, then the schedule
  will be subject to automatic deletion (after several days).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`calendar`** | `Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec` | Calendar-based specifications of times. |
  | 8 | **`cron_string`** | `string` | cron_string holds a traditional cron specification as a string. It |
  | 5 | **`end_time`** | `Google.Protobuf.Timestamp` | If end_time is set, any timestamps after end_time will be skipped. |
  | 3 | **`exclude_calendar`** | `Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec` | Any timestamps matching any of exclude_* will be skipped. |
  | 9 | **`exclude_structured_calendar`** | `Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec` |  |
  | 2 | **`interval`** | `Temporal.Protos.Temporal.Api.Schedule.V1.IntervalSpec` | Interval-based specifications of times. |
  | 6 | **`jitter`** | `Google.Protobuf.Duration` | All timestamps will be incremented by a random value from 0 to this |
  | 4 | **`start_time`** | `Google.Protobuf.Timestamp` | If start_time is set, any timestamps before start_time will be skipped. |
  | 7 | **`structured_calendar`** | `Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec` | Calendar-based specifications of times. |
  | 11 | **`timezone_data`** | `bytes` |  |
  | 10 | **`timezone_name`** | `string` | Time zone to interpret all calendar-based specs in. |

  ### Additional Notes

    * `cron_string` (`string`): cron_string holds a traditional cron specification as a string. It
      accepts 5, 6, or 7 fields, separated by spaces, and interprets them the
      same way as CalendarSpec.
      5 fields:         minute, hour, day_of_month, month, day_of_week
      6 fields:         minute, hour, day_of_month, month, day_of_week, year
      7 fields: second, minute, hour, day_of_month, month, day_of_week, year
      If year is not given, it defaults to *. If second is not given, it
      defaults to 0.
      Shorthands @yearly, @monthly, @weekly, @daily, and @hourly are also
      accepted instead of the 5-7 time fields.
      Optionally, the string can be preceded by CRON_TZ=<timezone name> or
      TZ=<timezone name>, which will get copied to timezone_name. (There must
      not also be a timezone_name present.)
      Optionally "#" followed by a comment can appear at the end of the string.
      Note that the special case that some cron implementations have for
      treating day_of_month and day_of_week as "or" instead of "and" when both
      are set is not implemented.
      @every <interval>[/<phase>] is accepted and gets compiled into an
      IntervalSpec instead. <interval> and <phase> should be a decimal integer
      with a unit suffix s, m, h, or d.
    * `exclude_calendar` (`Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec`): Any timestamps matching any of exclude_* will be skipped.
      Deprecated. Use exclude_structured_calendar.
    * `jitter` (`Google.Protobuf.Duration`): All timestamps will be incremented by a random value from 0 to this
      amount of jitter. Default: 0
    * `start_time` (`Google.Protobuf.Timestamp`): If start_time is set, any timestamps before start_time will be skipped.
      (Together, start_time and end_time make an inclusive interval.)
    * `timezone_name` (`string`): Time zone to interpret all calendar-based specs in.

      If unset, defaults to UTC. We recommend using UTC for your application if
      at all possible, to avoid various surprising properties of time zones.

      Time zones may be provided by name, corresponding to names in the IANA
      time zone database (see https://www.iana.org/time-zones). The definition
      will be loaded by the Temporal server from the environment it runs in.

      If your application requires more control over the time zone definition
      used, it may pass in a complete definition in the form of a TZif file
      from the time zone database. If present, this will be used instead of
      loading anything from the environment. You are then responsible for
      updating timezone_data when the definition changes.

      Calendar spec matching is based on literal matching of the clock time
      with no special handling of DST: if you write a calendar spec that fires
      at 2:30am and specify a time zone that follows DST, that action will not
      be triggered on the day that has no 2:30am. Similarly, an action that
      fires at 1:30am will be triggered twice on the day that has two 1:30s.

      Also note that no actions are taken on leap-seconds (e.g. 23:59:60 UTC).

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :structured_calendar, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec,
    json_name: "structuredCalendar"

  field :cron_string, 8, repeated: true, type: :string, json_name: "cronString"
  field :calendar, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec
  field :interval, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.IntervalSpec

  field :exclude_calendar, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec,
    json_name: "excludeCalendar",
    deprecated: true

  field :exclude_structured_calendar, 9,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec,
    json_name: "excludeStructuredCalendar"

  field :start_time, 4, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :end_time, 5, type: Google.Protobuf.Timestamp, json_name: "endTime"
  field :jitter, 6, type: Google.Protobuf.Duration
  field :timezone_name, 10, type: :string, json_name: "timezoneName"
  field :timezone_data, 11, type: :bytes, json_name: "timezoneData"
end
