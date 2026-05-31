defmodule Temporal.Protos.Temporal.Api.Common.V1.WorkerVersionStamp do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:build_id, 1, type: :string, json_name: "buildId")
  field(:use_versioning, 3, type: :bool, json_name: "useVersioning")
end
