defmodule Temporal.Protos.Temporal.Api.Common.V1.Payloads do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:payloads, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)
end
