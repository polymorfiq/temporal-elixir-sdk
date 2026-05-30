defmodule Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityResult do
  @moduledoc """
  Result of a CancelActivityCommand.
  Treat both successful cancellation and no-op (activity is no longer running) as success.
  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3
end
