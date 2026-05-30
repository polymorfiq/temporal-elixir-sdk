defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus.HeaderEntry do
  @moduledoc """
  Callback to attach to various events in the system, e.g. workflow run completion.

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
