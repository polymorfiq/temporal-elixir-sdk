defmodule Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget do
  @moduledoc """
  Target to route requests to.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`external`** | `Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.External` |  |
  | 1 | **`worker`** | `Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.Worker` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :worker, 1, type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.Worker, oneof: 0

  field :external, 2,
    type: Temporal.Protos.Temporal.Api.Nexus.V1.EndpointTarget.External,
    oneof: 0
end
