defmodule Temporal.Protos.Temporal.Api.Schedule.V1.SchedulePolicies do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:overlap_policy, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ScheduleOverlapPolicy,
    json_name: "overlapPolicy",
    enum: true
  )

  field(:catchup_window, 2, type: Google.Protobuf.Duration, json_name: "catchupWindow")
  field(:pause_on_failure, 3, type: :bool, json_name: "pauseOnFailure")
  field(:keep_original_workflow_id, 4, type: :bool, json_name: "keepOriginalWorkflowId")
end
