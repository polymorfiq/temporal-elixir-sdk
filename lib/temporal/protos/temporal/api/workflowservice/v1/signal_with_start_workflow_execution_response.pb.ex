defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWithStartWorkflowExecutionResponse do
  @moduledoc """
  Automatically generated module for SignalWithStartWorkflowExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`run_id`** | `string` | The run id of the workflow that was started - or just signaled, if it was already running. |
  | 3 | **`signal_link`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Link to be associated with the WorkflowExecutionSignaled event. |
  | 2 | **`started`** | `bool` | If true, a new workflow was started. |

  ### Additional Notes

    * `signal_link` (`Temporal.Protos.Temporal.Api.Common.V1.Link`): Link to be associated with the WorkflowExecutionSignaled event.
      Added on the response to propagate the backlink.
      Available from Temporal server 1.31 and up.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :started, 2, type: :bool

  field :signal_link, 3,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link,
    json_name: "signalLink"
end
