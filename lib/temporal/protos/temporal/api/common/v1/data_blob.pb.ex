defmodule Temporal.Protos.Temporal.Api.Common.V1.DataBlob do
  @moduledoc """
  Automatically generated module for DataBlob

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`data`** | `bytes` |  |
  | 1 | **`encoding_type`** | `Temporal.Protos.Temporal.Api.Enums.V1.EncodingType` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :encoding_type, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.EncodingType,
    json_name: "encodingType",
    enum: true

  field :data, 2, type: :bytes
end
