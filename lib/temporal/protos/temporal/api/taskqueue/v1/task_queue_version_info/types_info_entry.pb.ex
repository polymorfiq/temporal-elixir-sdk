defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo.TypesInfoEntry do
  @moduledoc """
  Automatically generated module for TypesInfoEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `int32` | Task Queue info per Task Type. Key is the numerical value of the temporal.api.enums.v1.TaskQueueType enum. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo` | Task Reachability is eventually consistent; there may be a delay until it converges to the most |

  ### Additional Notes

    * `value` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo`): Task Reachability is eventually consistent; there may be a delay until it converges to the most
      accurate value but it is designed in a way to take the more conservative side until it converges.
      For example REACHABLE is more conservative than CLOSED_WORKFLOWS_ONLY.

      Note: future activities who inherit their workflow's Build ID but not its Task Queue will not be
      accounted for reachability as server cannot know if they'll happen as they do not use
      assignment rules of their Task Queue. Same goes for Child Workflows or Continue-As-New Workflows
      who inherit the parent/previous workflow's Build ID but not its Task Queue. In those cases, make
      sure to query reachability for the parent/previous workflow's Task Queue as well.

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :int32
  field :value, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo
end
