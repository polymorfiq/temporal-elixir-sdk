defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NamespaceInvalidStateFailure do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true)

  field(:allowed_states, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState,
    json_name: "allowedStates",
    enum: true
  )
end
