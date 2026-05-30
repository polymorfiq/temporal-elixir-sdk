defmodule Temporal.Protos.Temporal.Api.Command.V1.ScheduleActivityTaskCommandAttributes do
  @moduledoc """
  Automatically generated module for ScheduleActivityTaskCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`activity_id`** | `string` |  |
  | 2 | **`activity_type`** | `Temporal.Protos.Temporal.Api.Common.V1.ActivityType` |  |
  | 5 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` |  |
  | 10 | **`heartbeat_timeout`** | `Google.Protobuf.Duration` | Maximum permitted time between successful worker heartbeats. |
  | 6 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |
  | 14 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. If this message is not present, or any fields are not |
  | 12 | **`request_eager_execution`** | `bool` | Request to start the activity directly bypassing matching service and worker polling |
  | 11 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | Activities are provided by a default retry policy which is controlled through the service's |
  | 7 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Indicates how long the caller is willing to wait for activity completion. The "schedule" time |
  | 8 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Limits the time an activity task can stay in a task queue before a worker picks it up. The |
  | 9 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Maximum time an activity is allowed to execute after being picked up by a worker. This |
  | 4 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |
  | 13 | **`use_workflow_build_id`** | `bool` | If this is set, the activity would be assigned to the Build ID of the workflow. Otherwise, |

  ### Additional Notes

    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority metadata. If this message is not present, or any fields are not
      present, they inherit the values from the workflow.
    * `request_eager_execution` (`bool`): Request to start the activity directly bypassing matching service and worker polling
      The slot for executing the activity should be reserved when setting this field to true.
    * `retry_policy` (`Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy`): Activities are provided by a default retry policy which is controlled through the service's
      dynamic configuration. Retries will be attempted until `schedule_to_close_timeout` has
      elapsed. To disable retries set retry_policy.maximum_attempts to 1.
    * `schedule_to_close_timeout` (`Google.Protobuf.Duration`): Indicates how long the caller is willing to wait for activity completion. The "schedule" time
      is when the activity is initially scheduled, not when the most recent retry is scheduled.
      Limits how long retries will be attempted. Either this or `start_to_close_timeout` must be
      specified. When not specified, defaults to the workflow execution timeout.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `schedule_to_start_timeout` (`Google.Protobuf.Duration`): Limits the time an activity task can stay in a task queue before a worker picks it up. The
      "schedule" time is when the most recent retry is scheduled. This timeout should usually not
      be set: it's useful in specific scenarios like worker-specific task queues. This timeout is
      always non retryable, as all a retry would achieve is to put it back into the same queue.
      Defaults to `schedule_to_close_timeout` or workflow execution timeout if that is not
      specified. More info:
      https://docs.temporal.io/docs/content/what-is-a-schedule-to-start-timeout/

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `start_to_close_timeout` (`Google.Protobuf.Duration`): Maximum time an activity is allowed to execute after being picked up by a worker. This
      timeout is always retryable. Either this or `schedule_to_close_timeout` must be specified.

      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: "to" is used to indicate interval. --)
    * `use_workflow_build_id` (`bool`): If this is set, the activity would be assigned to the Build ID of the workflow. Otherwise,
      Assignment rules of the activity's Task Queue will be used to determine the Build ID.

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

  field :retry_policy, 11,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :request_eager_execution, 12, type: :bool, json_name: "requestEagerExecution"
  field :use_workflow_build_id, 13, type: :bool, json_name: "useWorkflowBuildId"
  field :priority, 14, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
end
