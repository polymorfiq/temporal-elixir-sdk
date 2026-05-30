defmodule Temporal.Protos.Temporal.Api.History.V1.MarkerRecordedEventAttributes.DetailsEntry do
  @moduledoc """
  Automatically generated module for DetailsEntry

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Workers use this to identify the "types" of various markers. Ex: Local activity, side effect. |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized information recorded in the marker |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
end
