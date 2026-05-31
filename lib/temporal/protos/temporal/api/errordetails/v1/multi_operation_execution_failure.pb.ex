defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:statuses, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Errordetails.V1.MultiOperationExecutionFailure.OperationStatus
  )
end
