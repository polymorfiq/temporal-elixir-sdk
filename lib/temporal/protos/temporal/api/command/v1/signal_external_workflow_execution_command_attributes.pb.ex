defmodule Temporal.Protos.Temporal.Api.Command.V1.SignalExternalWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for SignalExternalWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`child_workflow_only`** | `bool` | Set this to true if the workflow being cancelled is a child of the workflow originating this |
  | 5 | **`control`** | `string` | Deprecated |
  | 2 | **`execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |
  | 7 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that are passed by the workflow that is sending a signal to the external  |
  | 4 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized value(s) to provide with the signal. |
  | 1 | **`namespace`** | `string` | Deprecated. Cross-namespace operations are disabled by default as of server 1.30.1. |
  | 3 | **`signal_name`** | `string` | The workflow author-defined name of the signal to send to the workflow. |

  ### Additional Notes

    * `child_workflow_only` (`bool`): Set this to true if the workflow being cancelled is a child of the workflow originating this
      command. The request will be rejected if it is set to true and the target workflow is *not*
      a child of the requesting workflow.
    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that are passed by the workflow that is sending a signal to the external 
      workflow that is receiving this signal.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string, deprecated: true
  field :execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  field :signal_name, 3, type: :string, json_name: "signalName"
  field :input, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :control, 5, type: :string, deprecated: true
  field :child_workflow_only, 6, type: :bool, json_name: "childWorkflowOnly"
  field :header, 7, type: Temporal.Protos.Temporal.Api.Common.V1.Header
end
