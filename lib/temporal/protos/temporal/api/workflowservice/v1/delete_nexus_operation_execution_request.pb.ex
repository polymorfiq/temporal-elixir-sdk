defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteNexusOperationExecutionRequest do
  @moduledoc """
  Automatically generated module for DeleteNexusOperationExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`operation_id`** | `string` |  |
  | 3 | **`run_id`** | `string` | Operation run ID, targets the latest run if empty. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :operation_id, 2, type: :string, json_name: "operationId"
  field :run_id, 3, type: :string, json_name: "runId"
end
