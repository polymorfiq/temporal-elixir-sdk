defmodule Temporal.Protos.Temporal.Api.Common.V1.ActivityType do
  @moduledoc """
  Represents the identifier used by a activity author to define the activity. Typically, the
  name of a function. This is sometimes referred to as the activity's "name"

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
end
