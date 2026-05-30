defmodule Temporal.Protos.Temporal.Api.Common.V1.Payload.ExternalPayloadDetails do
  @moduledoc """
  Represents some binary (byte array) data (ex: activity input parameters or workflow result) with
  metadata which describes this binary data (format, encoding, encryption, etc). Serialization
  of the data may be user-defined.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`size_bytes`** | `int64` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :size_bytes, 1, type: :int64, json_name: "sizeBytes"
end
