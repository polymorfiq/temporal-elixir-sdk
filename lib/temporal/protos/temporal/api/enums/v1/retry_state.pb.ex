defmodule Temporal.Protos.Temporal.Api.Enums.V1.RetryState do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :RETRY_STATE_UNSPECIFIED, 0
  field :RETRY_STATE_IN_PROGRESS, 1
  field :RETRY_STATE_NON_RETRYABLE_FAILURE, 2
  field :RETRY_STATE_TIMEOUT, 3
  field :RETRY_STATE_MAXIMUM_ATTEMPTS_REACHED, 4
  field :RETRY_STATE_RETRY_POLICY_NOT_SET, 5
  field :RETRY_STATE_INTERNAL_SERVER_ERROR, 6
  field :RETRY_STATE_CANCEL_REQUESTED, 7
end
