defmodule Temporal.Protos.Temporal.Api.Common.V1.Payload.ExternalPayloadDetails do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:size_bytes, 1, type: :int64, json_name: "sizeBytes")
end
