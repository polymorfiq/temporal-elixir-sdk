defmodule Temporal.Protos.Temporal.Api.Nexus.V1.HandlerError do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:error_type, 1, type: :string, json_name: "errorType")
  field(:failure, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure)

  field(:retry_behavior, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior,
    json_name: "retryBehavior",
    enum: true
  )
end
