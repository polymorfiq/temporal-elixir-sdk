defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeScheduleResponse do
  @moduledoc """
  Automatically generated module for DescribeScheduleResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`conflict_token`** | `bytes` | This value can be passed back to UpdateSchedule to ensure that the |
  | 2 | **`info`** | `Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleInfo` | Extra schedule state info. |
  | 3 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | The memo and search attributes that the schedule was created with. |
  | 1 | **`schedule`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Schedule` | The complete current schedule details. This may not match the schedule as |
  | 4 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |

  ### Additional Notes

    * `conflict_token` (`bytes`): This value can be passed back to UpdateSchedule to ensure that the
      schedule was not modified between a Describe and an Update, which could
      lead to lost updates and other confusion.
    * `schedule` (`Temporal.Protos.Temporal.Api.Schedule.V1.Schedule`): The complete current schedule details. This may not match the schedule as
      created because:
      - some types of schedule specs may get compiled into others (e.g.
        CronString into StructuredCalendarSpec)
      - some unspecified fields may be replaced by defaults
      - some fields in the state are modified automatically
      - the schedule may have been modified by UpdateSchedule or PatchSchedule

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :schedule, 1, type: Temporal.Protos.Temporal.Api.Schedule.V1.Schedule
  field :info, 2, type: Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleInfo
  field :memo, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :conflict_token, 5, type: :bytes, json_name: "conflictToken"
end
