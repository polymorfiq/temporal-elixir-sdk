defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UnpauseWorkflowExecutionRequest do
  @moduledoc """
  Automatically generated module for UnpauseWorkflowExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` | Namespace of the workflow to unpause. |
  | 5 | **`reason`** | `string` | Reason to unpause the workflow execution. |
  | 6 | **`request_id`** | `string` | A unique identifier for this unpause request for idempotence. Typically UUIDv4. |
  | 3 | **`run_id`** | `string` | Run ID of the workflow execution to be paused. Optional. If not provided, the current run of the workflow will be paused. |
  | 2 | **`workflow_id`** | `string` | ID of the workflow execution to be paused. Required. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :identity, 4, type: :string
  field :reason, 5, type: :string
  field :request_id, 6, type: :string, json_name: "requestId"
end
