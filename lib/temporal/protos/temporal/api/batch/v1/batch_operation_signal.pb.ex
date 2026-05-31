defmodule Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationSignal do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:signal, 1, type: :string)
  field(:input, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
  field(:header, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:identity, 4, type: :string)
end
