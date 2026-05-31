defmodule Temporal.Protos.Temporal.Api.Workflow.V1.ResetPointInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_id, 7, type: :string, json_name: "buildId")
  field(:binary_checksum, 1, type: :string, json_name: "binaryChecksum", deprecated: true)
  field(:run_id, 2, type: :string, json_name: "runId")

  field(:first_workflow_task_completed_id, 3,
    type: :int64,
    json_name: "firstWorkflowTaskCompletedId"
  )

  field(:create_time, 4, type: Google.Protobuf.Timestamp, json_name: "createTime")
  field(:expire_time, 5, type: Google.Protobuf.Timestamp, json_name: "expireTime")
  field(:resettable, 6, type: :bool)
end
