defmodule Temporal.Protos.Temporal.Api.History.V1.TimerCanceledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:timer_id, 1, type: :string, json_name: "timerId")
  field(:started_event_id, 2, type: :int64, json_name: "startedEventId")

  field(:workflow_task_completed_event_id, 3,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:identity, 4, type: :string)
end
