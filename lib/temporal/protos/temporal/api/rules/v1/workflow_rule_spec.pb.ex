defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec do
  @moduledoc """
  Automatically generated module for WorkflowRuleSpec

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`actions`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction` | WorkflowRuleAction to be taken when the rule is triggered and predicate is matched. |
  | 2 | **`activity_start`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec.ActivityStartingTrigger` |  |
  | 5 | **`expiration_time`** | `Google.Protobuf.Timestamp` | Expiration time of the rule. After this time, the rule will be deleted. |
  | 1 | **`id`** | `string` | The id of the new workflow rule. Must be unique within the namespace. |
  | 3 | **`visibility_query`** | `string` | Restricted Visibility query. |

  ### Additional Notes

    * `expiration_time` (`Google.Protobuf.Timestamp`): Expiration time of the rule. After this time, the rule will be deleted.
      Can be empty if the rule should never expire.
    * `id` (`string`): The id of the new workflow rule. Must be unique within the namespace.
      Can be set by the user, and can have business meaning.
    * `visibility_query` (`string`): Restricted Visibility query.
      This query is used to filter workflows in this namespace to which this rule should apply.
      It is applied to any running workflow each time a triggering event occurs, before the trigger predicate is evaluated.
      The following workflow attributes are supported:
      - WorkflowType
      - WorkflowId
      - StartTime
      - ExecutionStatus

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :trigger, 0

  field :id, 1, type: :string

  field :activity_start, 2,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec.ActivityStartingTrigger,
    json_name: "activityStart",
    oneof: 0

  field :visibility_query, 3, type: :string, json_name: "visibilityQuery"

  field :actions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleAction

  field :expiration_time, 5, type: Google.Protobuf.Timestamp, json_name: "expirationTime"
end
