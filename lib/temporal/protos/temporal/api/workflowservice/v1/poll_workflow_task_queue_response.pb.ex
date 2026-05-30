defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse do
  @moduledoc """
  Automatically generated module for PollWorkflowTaskQueueResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`attempt`** | `int32` | Starting at 1, the number of attempts to complete this task by any worker. |
  | 7 | **`backlog_count_hint`** | `int64` | A hint that there are more tasks already present in this task queue |
  | 8 | **`history`** | `Temporal.Protos.Temporal.Api.History.V1.History` | The history for this workflow, which will either be complete or partial. Partial histories |
  | 15 | **`messages`** | `Temporal.Protos.Temporal.Api.Protocol.V1.Message` | Protocol messages piggybacking on a WFT as a transport |
  | 9 | **`next_page_token`** | `bytes` | Will be set if there are more history events than were included in this response. Such events |
  | 17 | **`poller_group_id`** | `string` | This poller group ID identifies the owner of the workflow task awaiting for query response. |
  | 18 | **`poller_group_infos`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo` | The weighted list of poller groups IDs that client should use for future polls to this task |
  | 16 | **`poller_scaling_decision`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision` | Server-advised information the SDK may use to adjust its poller count. |
  | 4 | **`previous_started_event_id`** | `int64` | The last workflow task started event which was processed by some worker for this execution. |
  | 14 | **`queries`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse.QueriesEntry` | Queries that should be executed after applying the history in this task. Responses should be |
  | 10 | **`query`** | `Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery` | Legacy queries appear in this field. The query must be responded to via |
  | 12 | **`scheduled_time`** | `Google.Protobuf.Timestamp` | When this task was scheduled by the server |
  | 5 | **`started_event_id`** | `int64` | The id of the most recent workflow task started event, which will have been generated as a |
  | 13 | **`started_time`** | `Google.Protobuf.Timestamp` | When the current workflow task started event was generated, meaning the current attempt. |
  | 1 | **`task_token`** | `bytes` | A unique identifier for this task |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 11 | **`workflow_execution_task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` | The task queue this task originated from, which will always be the original non-sticky name |
  | 3 | **`workflow_type`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowType` |  |

  ### Additional Notes

    * `backlog_count_hint` (`int64`): A hint that there are more tasks already present in this task queue
      partition. Can be used to prioritize draining a sticky queue.

      Specifically, the returned number is the number of tasks remaining in
      the in-memory buffer for this partition, which is currently capped at
      1000. Because sticky queues only have one partition, this number is
      more useful when draining them. Normal queues, typically having more than one
      partition, will return a number representing only some portion of the
      overall backlog. Subsequent RPCs may not hit the same partition as
      this call.
    * `history` (`Temporal.Protos.Temporal.Api.History.V1.History`): The history for this workflow, which will either be complete or partial. Partial histories
      are sent to workers who have signaled that they are using a sticky queue when completing
      a workflow task.
    * `next_page_token` (`bytes`): Will be set if there are more history events than were included in this response. Such events
      should be fetched via `GetWorkflowExecutionHistory`.
    * `poller_group_id` (`string`): This poller group ID identifies the owner of the workflow task awaiting for query response.
      Corresponding RespondQueryTaskCompleted should pass this value for proper routing.
    * `poller_group_infos` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo`): The weighted list of poller groups IDs that client should use for future polls to this task
      queue. Client is expected to:
        1. Maintain minimum number of pollers no less than the number of groups.
        2. Try to assign the next poll to a group without any pending polls,
        3. If every group has some pending polls, assign the next poll to a group randomly
          according to the weights.
    * `previous_started_event_id` (`int64`): The last workflow task started event which was processed by some worker for this execution.
      Will be zero if no task has ever started.
    * `queries` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse.QueriesEntry`): Queries that should be executed after applying the history in this task. Responses should be
      attached to `RespondWorkflowTaskCompletedRequest::query_results`
    * `query` (`Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery`): Legacy queries appear in this field. The query must be responded to via
      `RespondQueryTaskCompleted`. If the workflow is already closed (queries are permitted on
      closed workflows) then the `history` field will be populated with the entire history. It
      may also be populated if this task originates on a non-sticky queue.
    * `started_event_id` (`int64`): The id of the most recent workflow task started event, which will have been generated as a
      result of this poll request being served. Will be zero if the task
      does not contain any events which would advance history (no new WFT started).
      Currently this can happen for queries.
    * `workflow_execution_task_queue` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue`): The task queue this task originated from, which will always be the original non-sticky name
      for the queue, even if this response came from polling a sticky queue.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :workflow_type, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowType,
    json_name: "workflowType"

  field :previous_started_event_id, 4, type: :int64, json_name: "previousStartedEventId"
  field :started_event_id, 5, type: :int64, json_name: "startedEventId"
  field :attempt, 6, type: :int32
  field :backlog_count_hint, 7, type: :int64, json_name: "backlogCountHint"
  field :history, 8, type: Temporal.Protos.Temporal.Api.History.V1.History
  field :next_page_token, 9, type: :bytes, json_name: "nextPageToken"
  field :query, 10, type: Temporal.Protos.Temporal.Api.Query.V1.WorkflowQuery

  field :workflow_execution_task_queue, 11,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "workflowExecutionTaskQueue"

  field :scheduled_time, 12, type: Google.Protobuf.Timestamp, json_name: "scheduledTime"
  field :started_time, 13, type: Google.Protobuf.Timestamp, json_name: "startedTime"

  field :queries, 14,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.PollWorkflowTaskQueueResponse.QueriesEntry,
    map: true

  field :messages, 15, repeated: true, type: Temporal.Protos.Temporal.Api.Protocol.V1.Message

  field :poller_scaling_decision, 16,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision,
    json_name: "pollerScalingDecision"

  field :poller_group_id, 17, type: :string, json_name: "pollerGroupId"

  field :poller_group_infos, 18,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
end
