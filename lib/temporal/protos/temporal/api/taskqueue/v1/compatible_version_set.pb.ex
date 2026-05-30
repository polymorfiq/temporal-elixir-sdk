defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet do
  @moduledoc """
  Used by the worker versioning APIs, represents an unordered set of one or more versions which are
  considered to be compatible with each other. Currently the versions are always worker build IDs.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_ids`** | `string` | All the compatible versions, unordered, except for the last element, which is considered the set "default". |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_ids, 1, repeated: true, type: :string, json_name: "buildIds"
end
