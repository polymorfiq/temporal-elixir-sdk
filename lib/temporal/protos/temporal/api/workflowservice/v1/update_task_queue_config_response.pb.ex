defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateTaskQueueConfigResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:config, 1, type: Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueConfig)
end
