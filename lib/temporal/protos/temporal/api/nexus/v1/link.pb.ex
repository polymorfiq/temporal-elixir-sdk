defmodule Temporal.Protos.Temporal.Api.Nexus.V1.Link do
  @moduledoc """
  Automatically generated module for Link

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`type`** | `string` |  |
  | 1 | **`url`** | `string` | See https://github.com/nexus-rpc/api/blob/main/SPEC.md#links. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :url, 1, type: :string
  field :type, 2, type: :string
end
