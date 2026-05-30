defmodule Temporal.Protos.Temporal.Api.Common.V1.Principal do
  @moduledoc """
  Principal is an authenticated caller identity computed by the server from trusted
  authentication context.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`name`** | `string` | Identifier within that category (e.g., sub JWT claim, email address). |
  | 1 | **`type`** | `string` | Low-cardinality category of the principal (e.g., "jwt", "users"). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string
  field :name, 2, type: :string
end
