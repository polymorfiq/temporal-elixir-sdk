defmodule Temporal.Protos.Temporal.Api.Common.V1.Payload do
  @moduledoc """
  Represents some binary (byte array) data (ex: activity input parameters or workflow result) with
  metadata which describes this binary data (format, encoding, encryption, etc). Serialization
  of the data may be user-defined.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`data`** | `bytes` |  |
  | 3 | **`external_payloads`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload.ExternalPayloadDetails` | Details about externally stored payloads associated with this payload. |
  | 1 | **`metadata`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload.MetadataEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :metadata, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload.MetadataEntry,
    map: true

  field :data, 2, type: :bytes

  field :external_payloads, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Payload.ExternalPayloadDetails,
    json_name: "externalPayloads"
end
