defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:execution_expiration_time, 1,
    type: Google.Protobuf.Timestamp,
    json_name: "executionExpirationTime"
  )

  field(:run_expiration_time, 2, type: Google.Protobuf.Timestamp, json_name: "runExpirationTime")
  field(:cancel_requested, 3, type: :bool, json_name: "cancelRequested")
  field(:last_reset_time, 4, type: Google.Protobuf.Timestamp, json_name: "lastResetTime")
  field(:original_start_time, 5, type: Google.Protobuf.Timestamp, json_name: "originalStartTime")
  field(:reset_run_id, 6, type: :string, json_name: "resetRunId")

  field(:request_id_infos, 7,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo.RequestIdInfosEntry,
    json_name: "requestIdInfos",
    map: true
  )

  field(:pause_info, 8,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionPauseInfo,
    json_name: "pauseInfo"
  )
end
