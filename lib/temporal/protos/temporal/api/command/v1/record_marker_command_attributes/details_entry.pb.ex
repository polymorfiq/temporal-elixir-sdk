defmodule Temporal.Protos.Temporal.Api.Command.V1.RecordMarkerCommandAttributes.DetailsEntry do
  @moduledoc """
  Automatically generated module for DetailsEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
