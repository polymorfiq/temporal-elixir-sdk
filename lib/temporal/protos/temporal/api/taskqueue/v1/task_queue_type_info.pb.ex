defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:pollers, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerInfo)
  field(:stats, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueStats)
end
