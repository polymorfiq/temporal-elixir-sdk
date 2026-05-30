defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RequestCancelNexusOperationExecutionRequest do
  @moduledoc """
  Automatically generated module for RequestCancelNexusOperationExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`operation_id`** | `string` |  |
  | 6 | **`reason`** | `string` | Reason for requesting the cancellation, recorded and available via the DescribeNexusOperationExecution API. |
  | 5 | **`request_id`** | `string` | Used to de-dupe cancellation requests. |
  | 3 | **`run_id`** | `string` | Operation run ID, targets the latest run if empty. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :operation_id, 2, type: :string, json_name: "operationId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :identity, 4, type: :string
  field :request_id, 5, type: :string, json_name: "requestId"
  field :reason, 6, type: :string
end
