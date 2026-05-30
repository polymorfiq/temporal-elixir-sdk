defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTermination do
  @moduledoc """
  BatchOperationTermination sends terminate requests to batch workflows.
  Keep the parameter in sync with temporal.api.workflowservice.v1.TerminateWorkflowExecutionRequest.
  Ignore first_execution_run_id because this is used for single workflow operation.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`details`** | `Temporal.Protos.Temporal.Api.Common.V1.Payloads` | Serialized value(s) to provide to the termination event |
  | 2 | **`identity`** | `string` | The identity of the worker/client |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads
  field :identity, 2, type: :string
end
