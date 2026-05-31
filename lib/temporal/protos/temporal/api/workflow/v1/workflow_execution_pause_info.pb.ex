defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionPauseInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:identity, 1, type: :string)
  field(:paused_time, 2, type: Google.Protobuf.Timestamp, json_name: "pausedTime")
  field(:reason, 3, type: :string)
end
