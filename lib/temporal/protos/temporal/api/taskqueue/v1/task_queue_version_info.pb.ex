defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo do
  @moduledoc """
  Automatically generated module for TaskQueueVersionInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`task_reachability`** | `Temporal.Protos.Temporal.Api.Enums.V1.BuildIdTaskReachability` | Task Reachability is eventually consistent; there may be a delay until it converges to the most |
  | 1 | **`types_info`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo.TypesInfoEntry` | Task Queue info per Task Type. Key is the numerical value of the temporal.api.enums.v1.TaskQueueType enum. |

  ### Additional Notes

    * `task_reachability` (`Temporal.Protos.Temporal.Api.Enums.V1.BuildIdTaskReachability`): Task Reachability is eventually consistent; there may be a delay until it converges to the most
      accurate value but it is designed in a way to take the more conservative side until it converges.
      For example REACHABLE is more conservative than CLOSED_WORKFLOWS_ONLY.

      Note: future activities who inherit their workflow's Build ID but not its Task Queue will not be
      accounted for reachability as server cannot know if they'll happen as they do not use
      assignment rules of their Task Queue. Same goes for Child Workflows or Continue-As-New Workflows
      who inherit the parent/previous workflow's Build ID but not its Task Queue. In those cases, make
      sure to query reachability for the parent/previous workflow's Task Queue as well.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :types_info, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo.TypesInfoEntry,
    json_name: "typesInfo",
    map: true

  field :task_reachability, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.BuildIdTaskReachability,
    json_name: "taskReachability",
    enum: true
end
