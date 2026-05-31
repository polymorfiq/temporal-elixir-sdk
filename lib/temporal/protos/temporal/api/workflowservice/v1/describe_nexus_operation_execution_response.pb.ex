defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNexusOperationExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:outcome, 0)

  field(:run_id, 1, type: :string, json_name: "runId")
  field(:info, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionInfo)
  field(:input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
  field(:result, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payload, oneof: 0)
  field(:failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0)
  field(:long_poll_token, 6, type: :bytes, json_name: "longPollToken")
end
