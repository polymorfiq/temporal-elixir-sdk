defmodule Temporal.Protos.Temporal.Api.Common.V1.Payload do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:metadata, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload.MetadataEntry,
    map: true
  )

  field(:data, 2, type: :bytes)

  field(:external_payloads, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload.ExternalPayloadDetails,
    json_name: "externalPayloads"
  )
end
