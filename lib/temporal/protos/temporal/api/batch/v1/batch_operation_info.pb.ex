defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:job_id, 1, type: :string, json_name: "jobId")
  field(:state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState, enum: true)
  field(:start_time, 3, type: Google.Protobuf.Timestamp, json_name: "startTime")
  field(:close_time, 4, type: Google.Protobuf.Timestamp, json_name: "closeTime")
end
