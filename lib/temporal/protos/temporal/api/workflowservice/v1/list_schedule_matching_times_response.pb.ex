defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ListScheduleMatchingTimesResponse do
  @moduledoc """
  Automatically generated module for ListScheduleMatchingTimesResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`start_time`** | `Google.Protobuf.Timestamp` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :start_time, 1, repeated: true, type: Google.Protobuf.Timestamp, json_name: "startTime"
end
