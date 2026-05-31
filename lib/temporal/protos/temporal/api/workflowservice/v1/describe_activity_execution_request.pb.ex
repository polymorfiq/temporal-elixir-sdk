defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeActivityExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:activity_id, 2, type: :string, json_name: "activityId")
  field(:run_id, 3, type: :string, json_name: "runId")
  field(:include_input, 4, type: :bool, json_name: "includeInput")
  field(:include_outcome, 5, type: :bool, json_name: "includeOutcome")
  field(:long_poll_token, 6, type: :bytes, json_name: "longPollToken")
end
