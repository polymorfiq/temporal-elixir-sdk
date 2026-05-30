defmodule Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo do
  @moduledoc """
  ReleaseInfo contains information about specific version of temporal.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`notes`** | `string` |  |
  | 2 | **`release_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`version`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :version, 1, type: :string
  field :release_time, 2, type: Google.Protobuf.Timestamp, json_name: "releaseTime"
  field :notes, 3, type: :string
end
