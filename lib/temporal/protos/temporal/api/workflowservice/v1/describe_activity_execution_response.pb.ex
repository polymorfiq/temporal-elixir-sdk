defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeActivityExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:run_id, 1, type: :string, json_name: "runId")
  field(:info, 2, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionInfo)
  field(:input, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:outcome, 4, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome)
  field(:long_poll_token, 5, type: :bytes, json_name: "longPollToken")

  field(:callbacks, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Activity.V1.CallbackInfo
  )
end
