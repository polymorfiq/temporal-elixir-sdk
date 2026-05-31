defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskScheduledEventAttributes do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:activity_id, 1, type: :string, json_name: "activityId")

  field(:activity_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:task_queue, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"
  )

  field(:header, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:input, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"
  )

  field(:start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout")

  field(:workflow_task_completed_event_id, 11,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"
  )

  field(:retry_policy, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:use_workflow_build_id, 13,
    type: :bool,
    json_name: "useWorkflowBuildId",
    deprecated: true
  )

  field(:priority, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
end
