defmodule Temporal.Protos.Temporal.Api.Common.V1.RetryPolicy do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:initial_interval, 1, type: Google.Protobuf.Duration, json_name: "initialInterval")
  field(:backoff_coefficient, 2, type: :double, json_name: "backoffCoefficient")
  field(:maximum_interval, 3, type: Google.Protobuf.Duration, json_name: "maximumInterval")
  field(:maximum_attempts, 4, type: :int32, json_name: "maximumAttempts")

  field(:non_retryable_error_types, 5,
    repeated: true,
    type: :string,
    json_name: "nonRetryableErrorTypes"
  )
end
