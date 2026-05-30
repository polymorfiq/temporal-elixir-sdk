defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartNexusOperationExecutionResponse do
  @moduledoc """
  Automatically generated module for StartNexusOperationExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`run_id`** | `string` | The run ID of the operation that was started - or used (via NEXUS_OPERATION_ID_CONFLICT_POLICY_USE_EXISTING). |
  | 2 | **`started`** | `bool` | If true, a new operation was started. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :started, 2, type: :bool
end
