defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionSignaledEventAttributes do
  @moduledoc """
  Automatically generated module for WorkflowExecutionSignaledEventAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 6 | **`external_workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | When signal origin is a workflow execution, this field is set. |
  | 4 | **`header`** | `Temporal.Protos.Temporal.Api.Common.V1.Header` | Headers that were passed by the sender of the signal and copied by temporal |
  | 3 | **`identity`** | `string` | id of the worker/client who sent this signal |
  | 2 | **`input`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Will be deserialized and provided as argument(s) to the signal handler |
  | 7 | **`request_id`** | `string` | The request ID of the Signal request, used by the server to attach this to |
  | 1 | **`signal_name`** | `string` | The name/type of the signal to fire |
  | 5 | **`skip_generate_workflow_task`** | `bool` | Deprecated. This field is never respected and should always be set to false. |

  ### Additional Notes

    * `header` (`Temporal.Protos.Temporal.Api.Common.V1.Header`): Headers that were passed by the sender of the signal and copied by temporal
      server into the workflow task.
    * `request_id` (`string`): The request ID of the Signal request, used by the server to attach this to
      the correct Event ID when generating link.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :signal_name, 1, type: :string, json_name: "signalName"
  field :input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 3, type: :string
  field :header, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Header

  field :skip_generate_workflow_task, 5,
    type: :bool,
    json_name: "skipGenerateWorkflowTask",
    deprecated: true

  field :external_workflow_execution, 6,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "externalWorkflowExecution"

  field :request_id, 7, type: :string, json_name: "requestId"
end
