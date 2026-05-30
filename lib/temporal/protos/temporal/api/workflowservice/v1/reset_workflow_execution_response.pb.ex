defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetWorkflowExecutionResponse do
  @moduledoc """
  Automatically generated module for ResetWorkflowExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`run_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
end
