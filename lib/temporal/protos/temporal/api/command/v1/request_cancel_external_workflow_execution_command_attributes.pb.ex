defmodule Temporal.Protos.Temporal.Api.Command.V1.RequestCancelExternalWorkflowExecutionCommandAttributes do
  @moduledoc """
  Automatically generated module for RequestCancelExternalWorkflowExecutionCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`child_workflow_only`** | `bool` | Set this to true if the workflow being cancelled is a child of the workflow originating this |
  | 4 | **`control`** | `string` | Deprecated. |
  | 1 | **`namespace`** | `string` | Deprecated. Cross-namespace operations are disabled by default as of server 1.30.1. |
  | 6 | **`reason`** | `string` | Reason for requesting the cancellation |
  | 3 | **`run_id`** | `string` |  |
  | 2 | **`workflow_id`** | `string` |  |

  ### Additional Notes

    * `child_workflow_only` (`bool`): Set this to true if the workflow being cancelled is a child of the workflow originating this
      command. The request will be rejected if it is set to true and the target workflow is *not*
      a child of the requesting workflow.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string, deprecated: true
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :control, 4, type: :string, deprecated: true
  field :child_workflow_only, 5, type: :bool, json_name: "childWorkflowOnly"
  field :reason, 6, type: :string
end
