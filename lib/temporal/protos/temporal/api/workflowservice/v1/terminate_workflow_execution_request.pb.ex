defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for TerminateWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized additional information to attach to the termination event |
  | 6 | **`first_execution_run_id`** | `string` | If set, this call will error if the most recent (if no run id is set on |
  | 5 | **`identity`** | `string` | The identity of the worker/client |
  | 7 | **`links`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Links to be associated with the WorkflowExecutionTerminated event. |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`reason`** | `string` |  |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  ### Additional Notes

    * `first_execution_run_id` (`string`): If set, this call will error if the most recent (if no run id is set on
      `workflow_execution`), or specified (if it is) workflow execution is not part of the same
      execution chain as this id.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :reason, 3, type: :string
  field :details, 4, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 5, type: :string
  field :first_execution_run_id, 6, type: :string, json_name: "firstExecutionRunId"
  field :links, 7, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
