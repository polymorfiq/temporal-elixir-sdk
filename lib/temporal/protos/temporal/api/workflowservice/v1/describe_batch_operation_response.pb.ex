defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeBatchOperationResponse do
  @moduledoc """
  Automatically generated module for DescribeBatchOperationResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`close_time`** | `Google.Protobuf.Timestamp` | Batch operation close time |
  | 7 | **`complete_operation_count`** | `int64` | Complete operation count |
  | 8 | **`failure_operation_count`** | `int64` | Failure operation count |
  | 9 | **`identity`** | `string` | Identity indicates the operator identity |
  | 2 | **`job_id`** | `string` | Batch job ID |
  | 1 | **`operation_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationType` | Batch operation type |
  | 10 | **`reason`** | `string` | Reason indicates the reason to stop a operation |
  | 4 | **`start_time`** | `Google.Protobuf.Timestamp` | Batch operation start time |
  | 3 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState` | Batch operation state |
  | 6 | **`total_operation_count`** | `int64` | Total operation count |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :operation_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationType,
    json_name: "operationType",
    enum: true

  field :job_id, 2, type: :string, json_name: "jobId"
  field :state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState, enum: true
  field :start_time, 4, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :close_time, 5, type: Google.Protobuf.Timestamp, json_name: "closeTime"
  field :total_operation_count, 6, type: :int64, json_name: "totalOperationCount"
  field :complete_operation_count, 7, type: :int64, json_name: "completeOperationCount"
  field :failure_operation_count, 8, type: :int64, json_name: "failureOperationCount"
  field :identity, 9, type: :string
  field :reason, 10, type: :string
end
