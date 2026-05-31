defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.ActivityExecutionAlreadyStartedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:start_request_id, 1, type: :string, json_name: "startRequestId")
  field(:run_id, 2, type: :string, json_name: "runId")
end
