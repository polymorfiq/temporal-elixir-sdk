defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersionSelection do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_ids, 1, repeated: true, type: :string, json_name: "buildIds")
  field(:unversioned, 2, type: :bool)
  field(:all_active, 3, type: :bool, json_name: "allActive")
end
