defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowMetadata do
  @moduledoc """
  The name of the query to retrieve this information is `__temporal_workflow_metadata`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`current_details`** | `string` | Current long-form details of the workflow's state. This is used by user interfaces to show |
  | 1 | **`definition`** | `Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowDefinition` | Metadata provided at declaration or creation time. |

  ### Additional Notes

    * `current_details` (`string`): Current long-form details of the workflow's state. This is used by user interfaces to show
      long-form text. This text may be formatted by the user interface.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :definition, 1, type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowDefinition
  field :current_details, 2, type: :string, json_name: "currentDetails"
end
