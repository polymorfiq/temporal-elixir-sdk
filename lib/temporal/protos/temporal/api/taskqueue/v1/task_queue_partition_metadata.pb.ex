defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueuePartitionMetadata do
  @moduledoc """
  Automatically generated module for TaskQueuePartitionMetadata

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` |  |
  | 2 | **`owner_host_name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :owner_host_name, 2, type: :string, json_name: "ownerHostName"
end
