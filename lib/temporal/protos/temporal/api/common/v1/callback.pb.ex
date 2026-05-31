defmodule Temporal.Protos.Temporal.Api.Common.V1.Callback do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:variant, 0)

  field(:nexus, 2, type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Nexus, oneof: 0)
  field(:internal, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Callback.Internal, oneof: 0)
  field(:links, 100, repeated: true, type: Temporal.Protos.Temporal.Api.Common.V1.Link)
end
