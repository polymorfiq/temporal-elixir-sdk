defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
  field(:identity, 3, type: :string)
  field(:id, 4, type: :string, oneof: 0)
  field(:type, 5, type: :string, oneof: 0)
  field(:match_all, 10, type: :bool, json_name: "matchAll", oneof: 0)
  field(:reset_heartbeat, 6, type: :bool, json_name: "resetHeartbeat")
  field(:keep_paused, 7, type: :bool, json_name: "keepPaused")
  field(:jitter, 8, type: Google.Protobuf.Duration)
  field(:restore_original_options, 9, type: :bool, json_name: "restoreOriginalOptions")
end
