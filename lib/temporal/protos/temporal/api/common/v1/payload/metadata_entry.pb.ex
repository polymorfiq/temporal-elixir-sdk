defmodule Temporal.Protos.Temporal.Api.Common.V1.Payload.MetadataEntry do
  @moduledoc """
  Represents some binary (byte array) data (ex: activity input parameters or workflow result) with
  metadata which describes this binary data (format, encoding, encryption, etc). Serialization
  of the data may be user-defined.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `bytes` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :bytes
end
