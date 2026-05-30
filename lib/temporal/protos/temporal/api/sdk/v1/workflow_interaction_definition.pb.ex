defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition do
  @moduledoc """
  (-- api-linter: core::0123::resource-annotation=disabled
      aip.dev/not-precedent: The `name` field is optional. --)
  (-- api-linter: core::0203::optional=disabled --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`description`** | `string` | An optional interaction description provided by the application. |
  | 1 | **`name`** | `string` | An optional name for the handler. If missing, it represents |

  ### Additional Notes

    * `description` (`string`): An optional interaction description provided by the application.
      By convention, external tools may interpret its first part,
      i.e., ending with a line break, as a summary of the description.
    * `name` (`string`): An optional name for the handler. If missing, it represents
      a dynamic handler that processes any interactions not handled by others.
      There is at most one dynamic handler per workflow and interaction kind.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :description, 2, type: :string
end
