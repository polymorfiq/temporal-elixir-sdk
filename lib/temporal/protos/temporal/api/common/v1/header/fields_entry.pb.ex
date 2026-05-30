defmodule Temporal.Protos.Temporal.Api.Common.V1.Header.FieldsEntry do
  @moduledoc """
  Contains metadata that can be attached to a variety of requests, like starting a workflow, and
  can be propagated between, for example, workflows and activities.

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
