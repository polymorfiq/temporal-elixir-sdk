defmodule Temporal.Protos.Temporal.Api.Filter.V1.WorkflowExecutionFilter do
  @moduledoc """
  Automatically generated module for WorkflowExecutionFilter

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`run_id`** | `string` |  |
  | 1 | **`workflow_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_id, 1, type: :string, json_name: "workflowId"
  field :run_id, 2, type: :string, json_name: "runId"
end
