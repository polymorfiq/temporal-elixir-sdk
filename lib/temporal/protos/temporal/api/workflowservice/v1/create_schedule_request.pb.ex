defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CreateScheduleRequest do
  @moduledoc """
  (-- api-linter: core::0203::optional=disabled
  aip.dev/not-precedent: field_behavior annotation not available in our gogo fork --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 4 | **`initial_patch`** | `Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch` | Optional initial patch (e.g. to run the action once immediately). |
  | 7 | **`memo`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo` | Memo and search attributes to attach to the schedule itself. |
  | 1 | **`namespace`** | `string` | The namespace the schedule should be created in. |
  | 6 | **`request_id`** | `string` | A unique identifier for this create request for idempotence. Typically UUIDv4. |
  | 3 | **`schedule`** | `Temporal.Protos.Temporal.Api.Schedule.V1.Schedule` | The schedule spec, policies, action, and initial state. |
  | 2 | **`schedule_id`** | `string` | The id of the new schedule. |
  | 8 | **`search_attributes`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
  field :schedule, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.Schedule

  field :initial_patch, 4,
    type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch,
    json_name: "initialPatch"

  field :identity, 5, type: :string
  field :request_id, 6, type: :string, json_name: "requestId"
  field :memo, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Memo

  field :search_attributes, 8,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
end
