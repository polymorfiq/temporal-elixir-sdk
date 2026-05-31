defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskCancelRequestedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:scheduled_event_id, 1, type: :int64, json_name: "scheduledEventId")

  field(:workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )
end
