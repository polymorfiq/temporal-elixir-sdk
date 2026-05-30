defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PatchScheduleRequest do
  @moduledoc """
  Automatically generated module for PatchScheduleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | The namespace of the schedule to patch. |
  | 3 | **`patch`** | `Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch` |  |
  | 5 | **`request_id`** | `string` | A unique identifier for this update request for idempotence. Typically UUIDv4. |
  | 2 | **`schedule_id`** | `string` | The id of the schedule to patch. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
  field :patch, 3, type: Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePatch
  field :identity, 4, type: :string
  field :request_id, 5, type: :string, json_name: "requestId"
end
