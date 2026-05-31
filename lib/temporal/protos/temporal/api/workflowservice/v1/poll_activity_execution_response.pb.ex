defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:run_id, 1, type: :string, json_name: "runId")
  field(:outcome, 2, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome)
end
