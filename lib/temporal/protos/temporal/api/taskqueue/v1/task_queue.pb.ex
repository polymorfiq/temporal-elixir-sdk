defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueue do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:kind, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueKind, enum: true)
  field(:normal_name, 3, type: :string, json_name: "normalName")
end
