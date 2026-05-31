defmodule Temporal.Protos.Temporal.Api.Version.V1.Alert do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:message, 1, type: :string)
  field(:severity, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.Severity, enum: true)
end
