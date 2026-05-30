defmodule Temporal.Protos.Temporal.Api.Common.V1.Memo do
  @moduledoc """
  A user-defined set of *unindexed* fields that are exposed when listing/searching workflows

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`fields`** | `Temporal.Protos.Temporal.Api.Common.V1.Memo.FieldsEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :fields, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Memo.FieldsEntry,
    map: true
end
