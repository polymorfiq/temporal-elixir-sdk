defmodule Temporal.Protos.Temporal.Api.History.V1.NexusOperationCancelRequestFailedEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:requested_event_id, 1, type: :int64, json_name: "requestedEventId")

  field(:workflow_task_completed_event_id, 2,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:failure, 3, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:scheduled_event_id, 4, type: :int64, json_name: "scheduledEventId")
end
