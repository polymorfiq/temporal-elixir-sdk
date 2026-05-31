defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Failure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:message, 1, type: :string)
  field(:stack_trace, 4, type: :string, json_name: "stackTrace")

  field(:metadata, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure.MetadataEntry,
    map: true
  )

  field(:details, 3, type: :bytes)
  field(:cause, 5, type: Temporal.Protos.Temporal.Api.Nexus.V1.Failure)
end
