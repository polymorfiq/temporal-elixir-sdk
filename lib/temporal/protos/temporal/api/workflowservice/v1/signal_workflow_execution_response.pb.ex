defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWorkflowExecutionResponse do
  @moduledoc """
  Automatically generated module for SignalWorkflowExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`link`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Link to be associated with the WorkflowExecutionSignaled event. |

  ### Additional Notes

    * `link` (`Temporal.Protos.Temporal.Api.Common.V1.Link`): Link to be associated with the WorkflowExecutionSignaled event.
      Added on the response to propagate the backlink.
      Available from Temporal server 1.31 and up.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :link, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
