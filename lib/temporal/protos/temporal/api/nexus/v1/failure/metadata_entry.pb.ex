defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Failure.MetadataEntry do
  @moduledoc """
  A general purpose failure message.
  See: https://github.com/nexus-rpc/api/blob/main/SPEC.md#failure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `string` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
