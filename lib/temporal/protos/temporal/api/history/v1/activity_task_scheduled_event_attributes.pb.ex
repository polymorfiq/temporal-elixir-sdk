defmodule Temporal.Protos.Temporal.Api.History.V1.ActivityTaskScheduledEventAttributes do
  @moduledoc """
  Automatically generated module for ActivityTaskScheduledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_id`** | `string` | The worker/user assigned identifier for the activity |
  | 2 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` |  |
  | 5 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 10 | **`heartbeat_timeout`** | `Google.Protobuf.Duration` | Maximum permitted time between successful worker heartbeats. |
  | 6 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 14 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. If this message is not present, or any fields are not |
  | 12 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | Activities are assigned a default retry policy controlled by the service's dynamic |
  | 7 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Indicates how long the caller is willing to wait for an activity completion. Limits how long |
  | 8 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Limits time an activity task can stay in a task queue before a worker picks it up. This |
  | 9 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Maximum time an activity is allowed to execute after being picked up by a worker. This |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 13 | **`use_workflow_build_id`** | `bool` | If this is set, the activity would be assigned to the Build ID of the workflow. Otherwise, |
  | 11 | **`workflow_task_completed_event_id`** | `int64` | The `WORKFLOW_TASK_COMPLETED` event which this command was reported with |

  ### Additional Notes

    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority metadata. If this message is not present, or any fields are not
      present, they inherit the values from the workflow.
    * `retry_policy` (`Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy`): Activities are assigned a default retry policy controlled by the service's dynamic
      configuration. Retries will happen up to `schedule_to_close_timeout`. To disable retries set
      retry_policy.maximum_attempts to 1.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Indicates how long the caller is willing to wait for an activity completion. Limits how long
      retries will be attempted. Either this or `start_to_close_timeout` must be specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Limits time an activity task can stay in a task queue before a worker picks it up. This
      timeout is always non retryable, as all a retry would achieve is to put it back into the same
      queue. Defaults to `schedule_to_close_timeout` or workflow execution timeout if not
      specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Maximum time an activity is allowed to execute after being picked up by a worker. This
      timeout is always retryable. Either this or `schedule_to_close_timeout` must be
      specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `use_workflow_build_id` (`bool`): If this is set, the activity would be assigned to the Build ID of the workflow. Otherwise,
      Assignment rules of the activity's Task Queue will be used to determine the Build ID.
      Deprecated. This field should be cleaned up when versioning-2 API is removed. [cleanup-experimental-wv]

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :activity_id, 1, type: :string, json_name: "activityId"

  field :activity_type, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.ActivityType,
    json_name: "activityType"

  field :task_queue, 4,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :header, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :input, 6, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads

  field :schedule_to_close_timeout, 7,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :schedule_to_start_timeout, 8,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 9,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :heartbeat_timeout, 10, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout"

  field :workflow_task_completed_event_id, 11,
    type: :int64,
    json_name: "workflowTaskCompletedEventId"

  field :retry_policy, 12,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :use_workflow_build_id, 13, type: :bool, json_name: "useWorkflowBuildId", deprecated: true
  field :priority, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
end
