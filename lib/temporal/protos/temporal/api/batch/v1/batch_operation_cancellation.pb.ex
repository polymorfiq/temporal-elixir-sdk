defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationCancellation do
  @moduledoc """
  BatchOperationCancellation sends cancel requests to batch workflows.
  Keep the parameter in sync with temporal.api.workflowservice.v1.RequestCancelWorkflowExecutionRequest.
  Ignore first_execution_run_id because this is used for single workflow operation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker/client |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
end
