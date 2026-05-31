defmodule Temporal.Protos.Temporal.Api.Failure.V1.ServerFailureInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:non_retryable, 1, type: :bool, json_name: "nonRetryable")
end
