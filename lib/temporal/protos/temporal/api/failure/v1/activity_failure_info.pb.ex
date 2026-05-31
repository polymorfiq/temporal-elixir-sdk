defmodule Temporal.Protos.Temporal.Api.Failure.V1.ActivityFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")
  field(:identity, 3, type: :string)

  field(:activity_type, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:activity_id, 5, type: :string, json_name: "activityId")

  field(:retry_state, 6,
    type: Temporal.Protos.Temporal.Api.Enums.V1.RetryState,
    json_name: "retryState",
    enum: true
  )
end
