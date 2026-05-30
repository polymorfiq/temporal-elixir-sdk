defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowDefinition do
  @moduledoc """
  (-- api-linter: core::0203::optional=disabled --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`query_definitions`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition` | Query definitions, sorted by name. |
  | 3 | **`signal_definitions`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition` | Signal definitions, sorted by name. |
  | 1 | **`type`** | `string` | A name scoped by the task queue that maps to this workflow definition. |
  | 4 | **`update_definitions`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition` | Update definitions, sorted by name. |

  ### Additional Notes

    * `type` (`string`): A name scoped by the task queue that maps to this workflow definition.
      If missing, this workflow is a dynamic workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string

  field :query_definitions, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "queryDefinitions"

  field :signal_definitions, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "signalDefinitions"

  field :update_definitions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "updateDefinitions"
end
