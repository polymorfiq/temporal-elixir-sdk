defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateScheduleRequest do
  @moduledoc """
  Automatically generated module for UpdateScheduleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`conflict_token`** | `bytes` | This can be the value of conflict_token from a DescribeScheduleResponse, |
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 8 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | Schedule memo to replace. If set, replaces the entire memo. |
  | 1 | **`namespace`** | `string` | The namespace of the schedule to update. |
  | 6 | **`request_id`** | `string` | A unique identifier for this update request for idempotence. Typically UUIDv4. |
  | 3 | **`schedule`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Schedule` | The new schedule. The four main fields of the schedule (spec, action, |
  | 2 | **`schedule_id`** | `string` | The id of the schedule to update. |
  | 7 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` | Schedule search attributes to be updated. |

  ### Additional Notes

    * `conflict_token` (`bytes`): This can be the value of conflict_token from a DescribeScheduleResponse,
      which will cause this request to fail if the schedule has been modified
      between the Describe and this Update.
      If missing, the schedule will be updated unconditionally.
    * `memo` (`Temporal.Protos.Temporal.Api.Common.V1.Memo`): Schedule memo to replace. If set, replaces the entire memo.
      Do not set this field if you do not want to update the memo.
      A non-null empty object will clear the memo.
    * `schedule` (`Temporal.Protos.Temporal.Api.Schedule.V1.Schedule`): The new schedule. The four main fields of the schedule (spec, action,
      policies, state) are replaced completely by the values in this message.
    * `search_attributes` (`Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes`): Schedule search attributes to be updated.
      Do not set this field if you do not want to update the search attributes.
      A non-null empty object will set the search attributes to an empty map.
      Note: you cannot only update the search attributes with `UpdateScheduleRequest`,
      you must also set the `schedule` field; otherwise, it will unset the schedule.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
  field :schedule, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.Schedule
  field :conflict_token, 4, type: :bytes, json_name: "conflictToken"
  field :identity, 5, type: :string
  field :request_id, 6, type: :string, json_name: "requestId"

  field :search_attributes, 7,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"

  field :memo, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Memo
end
