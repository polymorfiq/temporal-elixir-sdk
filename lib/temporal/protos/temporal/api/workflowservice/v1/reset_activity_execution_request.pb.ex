defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetActivityExecutionRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:workflow_id, 2, type: :string, json_name: "workflowId")
  field(:activity_id, 3, type: :string, json_name: "activityId")
  field(:run_id, 4, type: :string, json_name: "runId")
  field(:identity, 5, type: :string)
  field(:reset_heartbeat, 6, type: :bool, json_name: "resetHeartbeat")
  field(:keep_paused, 7, type: :bool, json_name: "keepPaused")
  field(:jitter, 8, type: Google.Protobuf.Duration)
  field(:restore_original_options, 9, type: :bool, json_name: "restoreOriginalOptions")
  field(:resource_id, 10, type: :string, json_name: "resourceId")
end
