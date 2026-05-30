defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo do
  @moduledoc """
  Automatically generated module for TaskQueueTypeInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`pollers`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo` | Unversioned workers (with `useVersioning=false`) are reported in unversioned result even if they set a Build ID. |
  | 2 | **`stats`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :pollers, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo
  field :stats, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats
end
