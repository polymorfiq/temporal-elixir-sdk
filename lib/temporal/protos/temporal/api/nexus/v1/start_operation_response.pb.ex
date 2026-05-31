defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:sync_success, 1,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Sync,
    json_name: "syncSuccess",
    oneof: 0
  )

  field(:async_success, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Async,
    json_name: "asyncSuccess",
    oneof: 0
  )

  field(:operation_error, 3,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.UnsuccessfulOperationError,
    json_name: "operationError",
    oneof: 0,
    deprecated: true
  )

  field(:failure, 4, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure, oneof: 0)
end
