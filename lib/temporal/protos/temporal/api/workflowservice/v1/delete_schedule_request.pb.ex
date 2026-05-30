defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteScheduleRequest do
  @moduledoc """
  Automatically generated module for DeleteScheduleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | The namespace of the schedule to delete. |
  | 2 | **`schedule_id`** | `string` | The id of the schedule to delete. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
  field :identity, 3, type: :string
end
