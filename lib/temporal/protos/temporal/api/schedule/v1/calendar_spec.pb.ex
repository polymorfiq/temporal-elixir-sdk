defmodule Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec do
  @moduledoc """
  CalendarSpec describes an event specification relative to the calendar,
  similar to a traditional cron specification, but with labeled fields. Each
  field can be one of:
    *: matches always
    x: matches when the field equals x
    x/y : matches when the field equals x+n*y where n is an integer
    x-z: matches when the field is between x and z inclusive
    w,x,y,...: matches when the field is one of the listed values
  Each x, y, z, ... is either a decimal integer, or a month or day of week name
  or abbreviation (in the appropriate fields).
  A timestamp matches if all fields match.
  Note that fields have different default values, for convenience.
  Note that the special case that some cron implementations have for treating
  day_of_month and day_of_week as "or" instead of "and" when both are set is
  not implemented.
  day_of_week can accept 0 or 7 as Sunday
  CalendarSpec gets compiled into StructuredCalendarSpec, which is what will be
  returned if you describe the schedule.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 8 | **`comment`** | `string` | Free-form comment describing the intention of this spec. |
  | 4 | **`day_of_month`** | `string` | Expression to match days of the month. Default: * |
  | 7 | **`day_of_week`** | `string` | Expression to match days of the week. Default: * |
  | 3 | **`hour`** | `string` | Expression to match hours. Default: 0 |
  | 2 | **`minute`** | `string` | Expression to match minutes. Default: 0 |
  | 5 | **`month`** | `string` | Expression to match months. Default: * |
  | 1 | **`second`** | `string` | Expression to match seconds. Default: 0 |
  | 6 | **`year`** | `string` | Expression to match years. Default: * |

  ### Additional Notes

    * `day_of_month` (`string`): Expression to match days of the month. Default: *
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: standard name of field --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :second, 1, type: :string
  field :minute, 2, type: :string
  field :hour, 3, type: :string
  field :day_of_month, 4, type: :string, json_name: "dayOfMonth"
  field :month, 5, type: :string
  field :year, 6, type: :string
  field :day_of_week, 7, type: :string, json_name: "dayOfWeek"
  field :comment, 8, type: :string
end
