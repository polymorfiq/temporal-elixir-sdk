defmodule Temporal.Protos.Temporal.Api.Failure.V1.ApplicationFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)
  field(:non_retryable, 2, type: :bool, json_name: "nonRetryable")
  field(:details, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:next_retry_delay, 4, type: Google.Protobuf.Duration, json_name: "nextRetryDelay")

  field(:category, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ApplicationErrorCategory,
    enum: true
  )
end
