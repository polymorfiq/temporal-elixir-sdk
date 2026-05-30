defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution do
  @moduledoc """
  Identifies a specific workflow within a namespace. Practically speaking, because run_id is a
  uuid, a workflow execution is globally unique. Note that many commands allow specifying an empty
  run id as a way of saying "target the latest run of the workflow".

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
