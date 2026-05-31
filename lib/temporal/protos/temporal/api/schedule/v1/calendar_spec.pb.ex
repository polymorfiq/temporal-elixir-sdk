defmodule Temporal.Protos.Temporal.Api.Schedule.V1.CalendarSpec do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:second, 1, type: :string)
  field(:minute, 2, type: :string)
  field(:hour, 3, type: :string)
  field(:day_of_month, 4, type: :string, json_name: "dayOfMonth")
  field(:month, 5, type: :string)
  field(:year, 6, type: :string)
  field(:day_of_week, 7, type: :string, json_name: "dayOfWeek")
  field(:comment, 8, type: :string)
end
