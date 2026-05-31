defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.PermissionDeniedFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:reason, 1, type: :string)
end
