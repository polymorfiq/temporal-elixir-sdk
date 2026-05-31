defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.Worker do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:task_queue, 2, type: :string, json_name: "taskQueue")
end
