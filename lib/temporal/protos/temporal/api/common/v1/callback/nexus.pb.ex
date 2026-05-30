defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus do
  @moduledoc """
  Callback to attach to various events in the system, e.g. workflow run completion.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus.HeaderEntry` |  |
  | 1 | **`url`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :url, 1, type: :string

  field :header, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus.HeaderEntry,
    map: true
end
