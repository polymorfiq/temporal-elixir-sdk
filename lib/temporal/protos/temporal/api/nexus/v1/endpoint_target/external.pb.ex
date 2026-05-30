defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.External do
  @moduledoc """
  Target to route requests to.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`url`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :url, 1, type: :string
end
