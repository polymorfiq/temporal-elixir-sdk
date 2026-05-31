defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:name, 1, type: :string)
  field(:state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true)
  field(:description, 3, type: :string)
  field(:owner_email, 4, type: :string, json_name: "ownerEmail")

  field(:data, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.DataEntry,
    map: true
  )

  field(:id, 6, type: :string)

  field(:capabilities, 7,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Capabilities
  )

  field(:limits, 8, type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Limits)
  field(:supports_schedules, 100, type: :bool, json_name: "supportsSchedules")
end
