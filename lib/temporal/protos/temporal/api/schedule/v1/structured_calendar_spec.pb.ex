defmodule Temporal.Protos.Temporal.Api.Schedule.V1.StructuredCalendarSpec do
  @moduledoc """
  StructuredCalendarSpec describes an event specification relative to the
  calendar, in a form that's easy to work with programmatically. Each field can
  be one or more ranges.
  A timestamp matches if at least one range of each field matches the
  corresponding fields of the timestamp, except for year: if year is missing,
  that means all years match. For all fields besides year, at least one Range
  must be present to match anything.
  Relative expressions such as "last day of the month" or "third Monday" are not currently
  representable; callers must enumerate the concrete days they require.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 8 | **`comment`** | `string` | Free-form comment describing the intention of this spec. |
  | 4 | **`day_of_month`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match days of the month (1-31) |
  | 7 | **`day_of_week`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match days of the week (0-6; 0 is Sunday). |
  | 3 | **`hour`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match hours (0-23) |
  | 2 | **`minute`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match minutes (0-59) |
  | 5 | **`month`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match months (1-12) |
  | 1 | **`second`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match seconds (0-59) |
  | 6 | **`year`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Range` | Match years. |

  ### Additional Notes

    * `day_of_month` (`Temporal.Protos.Temporal.Api.Schedule.V1.Range`): Match days of the month (1-31)
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: standard name of field --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :second, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range
  field :minute, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range
  field :hour, 3, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range

  field :day_of_month, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.Range,
    json_name: "dayOfMonth"

  field :month, 5, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range
  field :year, 6, repeated: true, type: Temporal.Protos.Temporal.Api.Schedule.V1.Range

  field :day_of_week, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.Range,
    json_name: "dayOfWeek"

  field :comment, 8, type: :string
end
