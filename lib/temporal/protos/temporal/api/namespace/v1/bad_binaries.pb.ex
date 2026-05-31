defmodule Temporal.Protos.Temporal.Api.Namespace.V1.BadBinaries do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:binaries, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.BadBinaries.BinariesEntry,
    map: true
  )
end
