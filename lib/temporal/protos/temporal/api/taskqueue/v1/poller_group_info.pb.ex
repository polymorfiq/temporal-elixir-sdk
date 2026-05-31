defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:id, 1, type: :string)
  field(:weight, 2, type: :float)
end
