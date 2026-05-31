defmodule Temporal.Protos.Temporal.Api.Worker.V1.WorkerCommand do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:type, 0)

  field(:cancel_activity, 1,
    type: Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityCommand,
    json_name: "cancelActivity",
    oneof: 0
  )
end
