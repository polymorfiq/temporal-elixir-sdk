defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback.Internal do
  @moduledoc """
  Callback to attach to various events in the system, e.g. workflow run completion.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`data`** | `bytes` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :data, 1, type: :bytes
end
