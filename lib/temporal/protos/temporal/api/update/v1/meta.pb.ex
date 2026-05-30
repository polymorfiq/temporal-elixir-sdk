defmodule Temporal.Protos.Temporal.Api.Update.V1.Meta do
  @moduledoc """
  Metadata about a Workflow Update.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` | A string identifying the agent that requested this Update. |
  | 1 | **`update_id`** | `string` | An ID with workflow-scoped uniqueness for this Update. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :update_id, 1, type: :string, json_name: "updateId"
  field :identity, 2, type: :string
end
