defmodule Temporal.Protos.Temporal.Api.Nexusservices.Workerservice.V1.ExecuteCommandsRequest do
  @moduledoc """
  Request payload for the "ExecuteCommands" Nexus operation.
  (--
  Internal Nexus service for server-to-worker communication.
  --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`commands`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommand` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :commands, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommand
end
