defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo.Manual do
  @moduledoc """
  Automatically generated module for Manual

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` |  |
  | 2 | **`reason`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
  field :reason, 2, type: :string
end
