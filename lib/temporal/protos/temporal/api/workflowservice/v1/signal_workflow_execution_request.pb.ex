defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SignalWorkflowExecutionRequest do
  @moduledoc """
  Keep the parameters in sync with:
  - temporal.api.batch.v1.BatchOperationSignal.
  - temporal.api.workflow.v1.PostResetOperation.SignalWorkflow.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`control`** | `string` | Deprecated. |
  | 8 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that are passed with the signal to the processing workflow. |
  | 5 | **`identity`** | `string` | The identity of the worker/client |
  | 4 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized value(s) to provide with the signal |
  | 10 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the WorkflowExecutionSignaled event. |
  | 1 | **`namespace`** | `string` |  |
  | 6 | **`request_id`** | `string` | Used to de-dupe sent signals |
  | 3 | **`signal_name`** | `string` | The workflow author-defined name of the signal to send to the workflow |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  ### Additional Notes

    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that are passed with the signal to the processing workflow.
      These can include things like auth or tracing tokens.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :signal_name, 3, type: :string, json_name: "signalName"
  field :input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 5, type: :string
  field :request_id, 6, type: :string, json_name: "requestId"
  field :control, 7, type: :string, deprecated: true
  field :header, 8, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :links, 10, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
