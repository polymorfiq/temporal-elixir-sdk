defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.ResourceExhaustedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cause, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedCause, enum: true)
  field(:scope, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.ResourceExhaustedScope, enum: true)
end
