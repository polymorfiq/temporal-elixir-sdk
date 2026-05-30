defmodule Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo.PauseInfo.Rule do
  @moduledoc """
  Automatically generated module for Rule

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` |  |
  | 3 | **`reason`** | `string` |  |
  | 1 | **`rule_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :rule_id, 1, type: :string, json_name: "ruleId"
  field :identity, 2, type: :string
  field :reason, 3, type: :string
end
