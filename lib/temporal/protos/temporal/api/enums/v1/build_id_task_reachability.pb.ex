defmodule Temporal.Protos.Temporal.Api.Enums.V1.BuildIdTaskReachability do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :BUILD_ID_TASK_REACHABILITY_UNSPECIFIED, 0
  field :BUILD_ID_TASK_REACHABILITY_REACHABLE, 1
  field :BUILD_ID_TASK_REACHABILITY_CLOSED_WORKFLOWS_ONLY, 2
  field :BUILD_ID_TASK_REACHABILITY_UNREACHABLE, 3
end
