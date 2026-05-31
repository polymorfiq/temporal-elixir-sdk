defmodule Temporal.Protos.Temporal.Api.Nexus.V1.NexusOperationExecutionListInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_id, 1, type: :string, json_name: "operationId")
  field(:run_id, 2, type: :string, json_name: "runId")
  field(:endpoint, 3, type: :string)
  field(:service, 4, type: :string)
  field(:operation, 5, type: :string)
  field(:schedule_time, 6, type: Google.Protobuf.Timestamp, json_name: "scheduleTime")
  field(:close_time, 7, type: Google.Protobuf.Timestamp, json_name: "closeTime")

  field(:status, 8,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusOperationExecutionStatus,
    enum: true
  )

  field(:search_attributes, 9,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes,
    json_name: "searchAttributes"
  )

  field(:state_transition_count, 10, type: :int64, json_name: "stateTransitionCount")
  field(:execution_duration, 11, type: Google.Protobuf.Duration, json_name: "executionDuration")
  field(:state_size_bytes, 12, type: :int64, json_name: "stateSizeBytes")
end
