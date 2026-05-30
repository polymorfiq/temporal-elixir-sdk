defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommand do
  @moduledoc """
  A command sent from the server to a worker.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cancel_activity`** | `Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityCommand` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :type, 0

  field :cancel_activity, 1,
    type: Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityCommand,
    json_name: "cancelActivity",
    oneof: 0
end
