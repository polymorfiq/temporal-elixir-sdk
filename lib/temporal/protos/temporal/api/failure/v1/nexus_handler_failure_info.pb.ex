defmodule Temporal.Protos.Temporal.Api.Failure.V1.NexusHandlerFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)

  field(:retry_behavior, 2,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NexusHandlerErrorRetryBehavior,
    json_name: "retryBehavior",
    enum: true
  )
end
