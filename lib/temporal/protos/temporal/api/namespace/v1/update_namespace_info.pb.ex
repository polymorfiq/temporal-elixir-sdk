defmodule Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:description, 1, type: :string)
  field(:owner_email, 2, type: :string, json_name: "ownerEmail")

  field(:data, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo.DataEntry,
    map: true
  )

  field(:state, 4, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true)
end
