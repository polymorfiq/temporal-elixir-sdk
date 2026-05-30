defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationInfo do
  @moduledoc """
  Automatically generated module for BatchOperationInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`close_time`** | `Google.Protobuf.Timestamp` | Batch operation close time |
  | 1 | **`job_id`** | `string` | Batch job ID |
  | 3 | **`start_time`** | `Google.Protobuf.Timestamp` | Batch operation start time |
  | 2 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState` | Batch operation state |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :job_id, 1, type: :string, json_name: "jobId"
  field :state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState, enum: true
  field :start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime"
  field :close_time, 4, type: Google.Protobuf.Timestamp, json_name: "closeTime"
end
