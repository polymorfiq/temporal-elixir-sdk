defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.CompatibleVersionSet do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_ids, 1, repeated: true, type: :string, json_name: "buildIds")
end
