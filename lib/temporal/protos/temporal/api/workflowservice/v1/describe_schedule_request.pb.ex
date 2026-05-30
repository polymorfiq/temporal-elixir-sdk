defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeScheduleRequest do
  @moduledoc """
  Automatically generated module for DescribeScheduleRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` | The namespace of the schedule to describe. |
  | 2 | **`schedule_id`** | `string` | The id of the schedule to describe. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :schedule_id, 2, type: :string, json_name: "scheduleId"
end
