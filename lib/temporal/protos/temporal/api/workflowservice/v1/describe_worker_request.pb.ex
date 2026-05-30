defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkerRequest do
  @moduledoc """
  Automatically generated module for DescribeWorkerRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` | Namespace this worker belongs to. |
  | 2 | **`worker_instance_key`** | `string` | Worker instance key to describe. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :worker_instance_key, 2, type: :string, json_name: "workerInstanceKey"
end
