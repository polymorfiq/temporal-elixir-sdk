defmodule Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:TASK_REACHABILITY_UNSPECIFIED, 0)
  field(:TASK_REACHABILITY_NEW_WORKFLOWS, 1)
  field(:TASK_REACHABILITY_EXISTING_WORKFLOWS, 2)
  field(:TASK_REACHABILITY_OPEN_WORKFLOWS, 3)
  field(:TASK_REACHABILITY_CLOSED_WORKFLOWS, 4)
end
