defmodule Temporal.Protos.Temporal.Api.Update.V1.UpdateRef do
  @moduledoc """
  The data needed by a client to refer to a previously invoked Workflow Update.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`update_id`** | `string` |  |
  | 1 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_execution, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :update_id, 2, type: :string, json_name: "updateId"
end
