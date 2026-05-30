defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector do
  @moduledoc """
  This is used to send commands to a specific worker or a group of workers.
  Right now, it is used to send commands to a specific worker instance.
  Will be extended to be able to send command to multiple workers.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`worker_instance_key`** | `string` | Worker instance key to which the command should be sent. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :selector, 0

  field :worker_instance_key, 1, type: :string, json_name: "workerInstanceKey", oneof: 0
end
