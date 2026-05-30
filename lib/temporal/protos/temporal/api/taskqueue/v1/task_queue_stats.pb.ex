defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats do
  @moduledoc """
  TaskQueueStats contains statistics about task queue backlog and activity.

  For workflow task queue type, this result is partial because tasks sent to sticky queues are not included. Read
  comments above each metric to understand the impact of sticky queue exclusion on that metric accuracy.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`approximate_backlog_age`** | `Google.Protobuf.Duration` | Approximate age of the oldest task in the backlog based on the creation time of the task at the head of |
  | 1 | **`approximate_backlog_count`** | `int64` | The approximate number of tasks backlogged in this task queue. May count expired tasks but eventually |
  | 3 | **`tasks_add_rate`** | `float` | The approximate tasks per second added to the task queue, averaging the last 30 seconds. These includes tasks |
  | 4 | **`tasks_dispatch_rate`** | `float` | The approximate tasks per second dispatched from the task queue, averaging the last 30 seconds. These includes |

  ### Additional Notes

    * `approximate_backlog_age` (`Google.Protobuf.Duration`): Approximate age of the oldest task in the backlog based on the creation time of the task at the head of
      the queue. Can be relied upon for scaling decisions.

      Special note for workflow task queue type: this metric does not count sticky queue tasks. However, because
      those tasks only remain valid for a few seconds, they should not affect the result when backlog is older than
      few seconds.
    * `approximate_backlog_count` (`int64`): The approximate number of tasks backlogged in this task queue. May count expired tasks but eventually
      converges to the right value. Can be relied upon for scaling decisions.

      Special note for workflow task queue type: this metric does not count sticky queue tasks. However, because
      those tasks only remain valid for a few seconds, the inaccuracy becomes less significant as the backlog size
      grows.
    * `tasks_add_rate` (`float`): The approximate tasks per second added to the task queue, averaging the last 30 seconds. These includes tasks
      whether or not they were added to/dispatched from the backlog or they were dispatched immediately without going
      to the backlog (sync-matched).

      The difference between `tasks_add_rate` and `tasks_dispatch_rate` is a reliable metric for the rate at which
      backlog grows/shrinks.

      Note: the actual tasks delivered to the workers may significantly be higher than the numbers reported by
      tasks_add_rate, because:
      - Tasks can be sent to workers without going to the task queue. This is called Eager dispatch. Eager dispatch is
        enable for activities by default in the latest SDKs.
      - Tasks going to Sticky queue are not accounted for. Note that, typically, only the first workflow task of each
        workflow goes to a normal queue, and the rest workflow tasks go to the Sticky queue associated with a specific
        worker instance.
    * `tasks_dispatch_rate` (`float`): The approximate tasks per second dispatched from the task queue, averaging the last 30 seconds. These includes
      tasks whether or not they were added to/dispatched from the backlog or they were dispatched immediately without
      going to the backlog (sync-matched).

      The difference between `tasks_add_rate` and `tasks_dispatch_rate` is a reliable metric for the rate at which
      backlog grows/shrinks.

      Note: the actual tasks delivered to the workers may significantly be higher than the numbers reported by
      tasks_dispatch_rate, because:
      - Tasks can be sent to workers without going to the task queue. This is called Eager dispatch. Eager dispatch is
        enable for activities by default in the latest SDKs.
      - Tasks going to Sticky queue are not accounted for. Note that, typically, only the first workflow task of each
        workflow goes to a normal queue, and the rest workflow tasks go to the Sticky queue associated with a specific
        worker instance.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :approximate_backlog_count, 1, type: :int64, json_name: "approximateBacklogCount"

  field :approximate_backlog_age, 2,
    type: Google.Protobuf.Duration,
    json_name: "approximateBacklogAge"

  field :tasks_add_rate, 3, type: :float, json_name: "tasksAddRate"
  field :tasks_dispatch_rate, 4, type: :float, json_name: "tasksDispatchRate"
end
