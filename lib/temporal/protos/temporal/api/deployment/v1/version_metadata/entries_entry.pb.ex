defmodule Temporal.Protos.Temporal.Api.Deployment.V1.VersionMetadata.EntriesEntry do
  @moduledoc """
  Automatically generated module for EntriesEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Arbitrary key-values. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
