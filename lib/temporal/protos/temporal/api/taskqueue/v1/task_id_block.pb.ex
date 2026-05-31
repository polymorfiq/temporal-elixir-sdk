defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskIdBlock do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:start_id, 1, type: :int64, json_name: "startId")
  field(:end_id, 2, type: :int64, json_name: "endId")
end
