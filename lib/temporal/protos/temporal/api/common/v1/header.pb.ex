defmodule Temporal.Protos.Temporal.Api.Common.V1.Header do
  @moduledoc """
  Contains metadata that can be attached to a variety of requests, like starting a workflow, and
  can be propagated between, for example, workflows and activities.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`fields`** | `Temporal.Protos.Temporal.Api.Common.V1.Header.FieldsEntry` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :fields, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.Header.FieldsEntry,
    map: true
end
