defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:activity_id, 3, type: :string, json_name: "activityId")
  field(:run_id, 4, type: :string, json_name: "runId")
  field(:identity, 5, type: :string)
  field(:reset_attempts, 6, type: :bool, json_name: "resetAttempts")
  field(:reset_heartbeat, 7, type: :bool, json_name: "resetHeartbeat")
  field(:reason, 8, type: :string)
  field(:jitter, 9, type: Google.Protobuf.Duration)
  field(:resource_id, 10, type: :string, json_name: "resourceId")
end
