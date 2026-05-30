defmodule Temporal.Protos.Temporal.Api.Activity.V1.ActivityOptions do
  @moduledoc """
  Automatically generated module for ActivityOptions

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`heartbeat_timeout`** | `Google.Protobuf.Duration` | Maximum permitted time between successful worker heartbeats. |
  | 7 | **`priority`** | `Temporal.Protos.Temporal.Api.Common.V1.Priority` | Priority metadata. If this message is not present, or any fields are not |
  | 6 | **`retry_policy`** | `Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy` | The retry policy for the activity. Will never exceed `schedule_to_close_timeout`. |
  | 2 | **`schedule_to_close_timeout`** | `Google.Protobuf.Duration` | Indicates how long the caller is willing to wait for an activity completion. Limits how long |
  | 3 | **`schedule_to_start_timeout`** | `Google.Protobuf.Duration` | Limits time an activity task can stay in a task queue before a worker picks it up. This |
  | 4 | **`start_to_close_timeout`** | `Google.Protobuf.Duration` | Maximum time an activity is allowed to execute after being picked up by a worker. This |
  | 1 | **`task_queue`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue` |  |

  ### Additional Notes

    * `priority` (`Temporal.Protos.Temporal.Api.Common.V1.Priority`): Priority metadata. If this message is not present, or any fields are not
      present, they inherit the values from the workflow.
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

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_queue, 1,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue,
    json_name: "taskQueue"

  field :schedule_to_close_timeout, 2,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToCloseTimeout"

  field :schedule_to_start_timeout, 3,
    type: Google.Protobuf.Duration,
    json_name: "scheduleToStartTimeout"

  field :start_to_close_timeout, 4,
    type: Google.Protobuf.Duration,
    json_name: "startToCloseTimeout"

  field :heartbeat_timeout, 5, type: Google.Protobuf.Duration, json_name: "heartbeatTimeout"

  field :retry_policy, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy,
    json_name: "retryPolicy"

  field :priority, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Priority
end
