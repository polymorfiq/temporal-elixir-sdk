defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondWorkflowTaskCompletedResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:workflow_task, 1,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse,
    json_name: "workflowTask"
  )

  field(:activity_tasks, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueResponse,
    json_name: "activityTasks"
  )

  field(:reset_history_event_id, 3, type: :int64, json_name: "resetHistoryEventId")
end
