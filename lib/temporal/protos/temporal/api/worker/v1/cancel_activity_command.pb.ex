defmodule Temporal.Protos.Temporal.Api.Worker.V1.CancelActivityCommand do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
end
