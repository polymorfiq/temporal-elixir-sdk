defmodule Temporal.Protos.Temporal.Api.Failure.V1.ActivityFailureInfo do
  @moduledoc """
  Automatically generated module for ActivityFailureInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`activity_id`** | `string` |  |
  | 4 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` |  |
  | 3 | **`identity`** | `string` |  |
  | 6 | **`retry_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.RetryState` |  |
  | 1 | **`scheduled_event_id`** | `int64` |  |
  | 2 | **`started_event_id`** | `int64` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId"
  field :started_event_id, 2, type: :int64, json_name: "startedEventId"
  field :identity, 3, type: :string

  field :activity_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :activity_id, 5, type: :string, json_name: "activityId"

  field :retry_state, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
end
