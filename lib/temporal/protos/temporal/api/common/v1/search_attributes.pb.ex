defmodule Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes do
  @moduledoc """
  A user-defined set of *indexed* fields that are used/exposed when listing/searching workflows.
  The payload is not serialized in a user-defined way.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`indexed_fields`** | `Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes.IndexedFieldsEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :indexed_fields, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.SearchAttributes.IndexedFieldsEntry,
    json_name: "indexedFields",
    map: true
end
