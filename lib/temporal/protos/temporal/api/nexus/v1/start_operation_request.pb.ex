defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:service, 1, type: :string)
  field(:operation, 2, type: :string)
  field(:request_id, 3, type: :string, json_name: "requestId")
  field(:callback, 4, type: :string)
  field(:payload, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Payload)

  field(:callback_header, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationRequest.CallbackHeaderEntry,
    json_name: "callbackHeader",
    map: true
  )

  field(:links, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Link)
end
