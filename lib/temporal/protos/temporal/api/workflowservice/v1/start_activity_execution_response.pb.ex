defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:run_id, 1, type: :string, json_name: "runId")
  field(:started, 2, type: :bool)
  field(:link, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
