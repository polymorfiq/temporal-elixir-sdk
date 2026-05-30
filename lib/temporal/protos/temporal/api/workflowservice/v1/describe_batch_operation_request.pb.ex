defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeBatchOperationRequest do
  @moduledoc """
  Automatically generated module for DescribeBatchOperationRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`job_id`** | `string` | Batch job id |
  | 1 | **`namespace`** | `string` | Namespace that contains the batch operation |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :job_id, 2, type: :string, json_name: "jobId"
end
