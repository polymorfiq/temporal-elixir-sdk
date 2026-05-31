defmodule Temporal.Protos.Temporal.Api.Sdk.V1.StackTrace do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:locations, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.StackTraceFileLocation
  )
end
