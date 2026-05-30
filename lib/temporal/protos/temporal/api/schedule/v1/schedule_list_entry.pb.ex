defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleListEntry do
  @moduledoc """
  ScheduleListEntry is returned by ListSchedules.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`info`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleListInfo` |  |
  | 2 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` |  |
  | 1 | **`schedule_id`** | `string` |  |
  | 3 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :schedule_id, 1, type: :string, json_name: "scheduleId"
  field :memo, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :info, 4, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleListInfo
end
