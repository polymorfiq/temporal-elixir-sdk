defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionInfo.TypesInfoEntry do
  @moduledoc false
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:key, 1, type: :int32)
  field(:value, 2, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueTypeInfo)
end
