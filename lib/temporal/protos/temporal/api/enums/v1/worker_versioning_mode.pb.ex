defmodule Temporal.Protos.Temporal.Api.Enums.V1.WorkerVersioningMode do
  @moduledoc false
  use Protobuf, enum: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :WORKER_VERSIONING_MODE_UNSPECIFIED, 0
  field :WORKER_VERSIONING_MODE_UNVERSIONED, 1
  field :WORKER_VERSIONING_MODE_VERSIONED, 2
end
