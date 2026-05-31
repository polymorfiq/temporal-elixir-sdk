defmodule Temporal.Protos.Google.Api.Http do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:rules, 1, repeated: true, type: Temporal.Protos.Google.Api.HttpRule)

  field(:fully_decode_reserved_expansion, 2,
    type: :bool,
    json_name: "fullyDecodeReservedExpansion"
  )
end
