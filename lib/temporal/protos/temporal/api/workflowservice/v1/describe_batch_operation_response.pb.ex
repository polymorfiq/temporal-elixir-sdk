defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeBatchOperationResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:operation_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationType,
    json_name: "operationType",
    enum: true
  )

  field(:job_id, 2, type: :string, json_name: "jobId")
  field(:state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState, enum: true)
  field(:start_time, 4, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:close_time, 5, type: Google.Protobuf.Timestamp, json_name: "closeTime")
  field(:total_operation_count, 6, type: :int64, json_name: "totalOperationCount")
  field(:complete_operation_count, 7, type: :int64, json_name: "completeOperationCount")
  field(:failure_operation_count, 8, type: :int64, json_name: "failureOperationCount")
  field(:identity, 9, type: :string)
  field(:reason, 10, type: :string)
end
