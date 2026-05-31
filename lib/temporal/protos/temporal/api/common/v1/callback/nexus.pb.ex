defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:url, 1, type: :string)

  field(:header, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus.HeaderEntry,
    map: true
  )
end
