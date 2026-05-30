defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StopBatchOperationRequest do
  @moduledoc """
  Automatically generated module for StopBatchOperationRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`identity`** | `string` | Identity of the operator |
  | 2 | **`job_id`** | `string` | Batch job id |
  | 1 | **`namespace`** | `string` | Namespace that contains the batch operation |
  | 3 | **`reason`** | `string` | Reason to stop a batch operation |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :job_id, 2, type: :string, json_name: "jobId"
  field :reason, 3, type: :string
  field :identity, 4, type: :string
end
