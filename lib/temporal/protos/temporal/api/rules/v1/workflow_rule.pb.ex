defmodule Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRule do
  @moduledoc """
  WorkflowRule describes a rule that can be applied to any workflow in this namespace.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`create_time`** | `Google.Protobuf.Timestamp` | Rule creation time. |
  | 3 | **`created_by_identity`** | `string` | Identity of the actor that created the rule |
  | 4 | **`description`** | `string` | Rule description. |
  | 2 | **`spec`** | `Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec` | Rule specification |

  ### Additional Notes

    * `created_by_identity` (`string`): Identity of the actor that created the rule
      (-- api-linter: core::0140::prepositions=disabled
          aip.dev/not-precedent: It is better reflect the intent this way, we will also have updated_by. --)
      (-- api-linter: core::0142::time-field-names=disabled
          aip.dev/not-precedent: Same as above. All other options sounds clumsy --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :create_time, 1, type: Google.Protobuf.Timestamp, json_name: "createTime"
  field :spec, 2, type: Temporal.Protos.Temporal.Api.Rules.V1.WorkflowRuleSpec
  field :created_by_identity, 3, type: :string, json_name: "createdByIdentity"
  field :description, 4, type: :string
end
