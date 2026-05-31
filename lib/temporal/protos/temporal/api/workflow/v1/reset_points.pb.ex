defmodule Temporal.Protos.Temporal.Api.Workflow.V1.ResetPoints do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:points, 1, repeated: true, type: Temporal.Protos.Temporal.Api.Workflow.V1.ResetPointInfo)
end
