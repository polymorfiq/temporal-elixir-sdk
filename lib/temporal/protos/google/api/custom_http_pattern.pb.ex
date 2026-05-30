defmodule Temporal.Protos.Google.Api.CustomHttpPattern do
  @moduledoc """
  A custom pattern is used for defining custom HTTP verb.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`kind`** | `string` | The name of this custom HTTP verb. |
  | 2 | **`path`** | `string` | The path matched by this custom verb. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :kind, 1, type: :string
  field :path, 2, type: :string
end
