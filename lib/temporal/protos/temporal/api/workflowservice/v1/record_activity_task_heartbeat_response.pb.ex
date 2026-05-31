defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RecordActivityTaskHeartbeatResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cancel_requested, 1, type: :bool, json_name: "cancelRequested")
  field(:activity_paused, 2, type: :bool, json_name: "activityPaused")
  field(:activity_reset, 3, type: :bool, json_name: "activityReset")
end
