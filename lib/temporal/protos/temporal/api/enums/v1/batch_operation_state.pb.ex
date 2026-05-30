defmodule Temporal.Protos.Temporal.Api.Enums.V1.BatchOperationState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :BATCH_OPERATION_STATE_UNSPECIFIED, 0
  field :BATCH_OPERATION_STATE_RUNNING, 1
  field :BATCH_OPERATION_STATE_COMPLETED, 2
  field :BATCH_OPERATION_STATE_FAILED, 3
end
