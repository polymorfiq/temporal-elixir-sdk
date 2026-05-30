defmodule Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes.IndexedFieldsEntry do
  @moduledoc """
  A user-defined set of *indexed* fields that are used/exposed when listing/searching workflows.
  The payload is not serialized in a user-defined way.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`value`** | `Temporal.Protos.Temporal.Api.Common.V1.Payload` |  |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payload
end
