defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseActivityRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:identity, 3, type: :string)
  field(:id, 4, type: :string, oneof: 0)
  field(:type, 5, type: :string, oneof: 0)
  field(:unpause_all, 6, type: :bool, json_name: "unpauseAll", oneof: 0)
  field(:reset_attempts, 7, type: :bool, json_name: "resetAttempts")
  field(:reset_heartbeat, 8, type: :bool, json_name: "resetHeartbeat")
  field(:jitter, 9, type: Google.Protobuf.Duration)
end
