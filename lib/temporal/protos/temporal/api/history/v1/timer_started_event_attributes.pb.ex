defmodule Temporal.Protos.Temporal.Api.History.V1.TimerStartedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:timer_id, 1, type: :string, json_name: "timerId")

  field(:start_to_fire_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "startToFireTimeout"
  )

  field(:workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )
end
