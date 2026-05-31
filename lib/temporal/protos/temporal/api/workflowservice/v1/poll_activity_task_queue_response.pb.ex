defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityTaskQueueResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:workflow_namespace, 2, type: :string, json_name: "workflowNamespace")

  field(:workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:workflow_execution, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:activity_type, 5,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"
  )

  field(:activity_id, 6, type: :string, json_name: "activityId")
  field(:header, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:input, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)

  field(:heartbeat_details, 9,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payloads,
    json_name: "heartbeatDetails"
  )

  field(:scheduled_time, 10, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")

  field(:current_attempt_scheduled_time, 11,
    type: Google.Protobuf.Timestamp,
    json_name: "currentAttemptScheduledTime"
  )

  field(:started_time, 12, type: Google.Protobuf.Timestamp, json_name: "startedTime")
  field(:attempt, 13, type: :int32)

  field(:schedule_to_close_timeout, 14,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"
  )

  field(:start_to_close_timeout, 15,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"
  )

  field(:heartbeat_timeout, 16, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout")

  field(:retry_policy, 17,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"
  )

  field(:poller_scaling_decision, 18,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision,
    json_name: "pollerScalingDecision"
  )

  field(:priority, 19, type: Temporal.Protos.Temporal.Api.Common.V1.Priority)
  field(:activity_run_id, 20, type: :string, json_name: "activityRunId")

  field(:poller_group_infos, 21,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
  )
end
