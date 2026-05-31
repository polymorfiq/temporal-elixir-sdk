defmodule Temporal.Protos.Temporal.Api.Update.V1.Input do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:header, 1, type: Temporal.Protos.Temporal.Api.Common.V1.Header)
  field(:name, 2, type: :string)
  field(:args, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Payloads)
end
