defmodule Temporal.Protos.Temporal.Api.Nexusservices.Workerservice.V1.ExecuteCommandsResponse do
  @moduledoc """
  Response payload for the "ExecuteCommands" Nexus operation.
  The results list must be 1:1 with the commands list in the request (same size and order).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`results`** | `Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommandResult` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :results, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommandResult
end
