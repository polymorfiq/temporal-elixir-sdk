defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesRequest do
  @moduledoc """
  Automatically generated module for ListScheduleMatchingTimesRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`end_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`namespace`** | `string` | The namespace of the schedule to query. |
  | 2 | **`schedule_id`** | `string` | The id of the schedule to query. |
  | 3 | **`start_time`** | `Google.Protobuf.Timestamp` | Time range to query. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
  field :start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :end_time, 4, type: Google.Protobuf.Timestamp, json_name: "endTime"
end
