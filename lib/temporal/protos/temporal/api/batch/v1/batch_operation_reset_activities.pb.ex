defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationResetActivities do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:activity, 0)

  field(:identity, 1, type: :string)
  field(:type, 2, type: :string, oneof: 0)
  field(:match_all, 3, type: :bool, json_name: "matchAll", oneof: 0)
  field(:reset_attempts, 4, type: :bool, json_name: "resetAttempts")
  field(:reset_heartbeat, 5, type: :bool, json_name: "resetHeartbeat")
  field(:keep_paused, 6, type: :bool, json_name: "keepPaused")
  field(:jitter, 7, type: Google.Protobuf.Duration)
  field(:restore_original_options, 8, type: :bool, json_name: "restoreOriginalOptions")
end
