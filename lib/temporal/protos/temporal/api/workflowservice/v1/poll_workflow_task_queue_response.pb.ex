defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")

  field(:workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"
  )

  field(:workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"
  )

  field(:previous_started_event_id, 4, type: :int64, json_name: "previousStartedEventId")
  field(:started_event_id, 5, type: :int64, json_name: "startedEventId")
  field(:attempt, 6, type: :int32)
  field(:backlog_count_hint, 7, type: :int64, json_name: "backlogCountHint")
  field(:history, 8, type: Temporal.Protos.Temporal.Api.History.V1.History)
  field(:next_page_token, 9, type: :bytes, json_name: "nextPageToken")
  field(:query, 10, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery)

  field(:workflow_execution_task_queue, 11,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "workflowExecutionTaskQueue"
  )

  field(:scheduled_time, 12, type: Google.Protobuf.Timestamp, json_name: "scheduledTime")
  field(:started_time, 13, type: Google.Protobuf.Timestamp, json_name: "startedTime")

  field(:queries, 14,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse.QueriesEntry,
    map: true
  )

  field(:messages, 15, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message)

  field(:poller_scaling_decision, 16,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision,
    json_name: "pollerScalingDecision"
  )

  field(:poller_group_id, 17, type: :string, json_name: "pollerGroupId")

  field(:poller_group_infos, 18,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
  )
end
