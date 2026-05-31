defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.QueryFailedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failure, 1, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
end
