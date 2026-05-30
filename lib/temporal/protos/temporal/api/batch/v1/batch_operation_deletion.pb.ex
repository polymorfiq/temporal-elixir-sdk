defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationDeletion do
  @moduledoc """
  BatchOperationDeletion sends deletion requests to batch workflows.
  Keep the parameter in sync with temporal.api.workflowservice.v1.DeleteWorkflowExecutionRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the worker/client |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
end
