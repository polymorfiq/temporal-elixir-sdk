defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec.ActivityStartingTrigger do
  @moduledoc """
  Automatically generated module for ActivityStartingTrigger

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`predicate`** | `string` | The id of the new workflow rule. Must be unique within the namespace. |

  ### Additional Notes

    * `predicate` (`string`): The id of the new workflow rule. Must be unique within the namespace.
      Can be set by the user, and can have business meaning.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :predicate, 1, type: :string
end
