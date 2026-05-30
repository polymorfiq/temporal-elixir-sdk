defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationSignal do
  @moduledoc """
  BatchOperationSignal sends signals to batch workflows.
  Keep the parameter in sync with temporal.api.workflowservice.v1.SignalWorkflowExecutionRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that are passed with the signal to the processing workflow. |
  | 4 | **`identity`** | `string` | The identity of the worker/client |
  | 2 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized value(s) to provide with the signal |
  | 1 | **`signal`** | `string` | The workflow author-defined name of the signal to send to the workflow |

  ### Additional Notes

    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that are passed with the signal to the processing workflow.
      These can include things like auth or tracing tokens.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :signal, 1, type: :string
  field :input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header
  field :identity, 4, type: :string
end
