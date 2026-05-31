defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTermination do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:details, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:identity, 2, type: :string)
end
