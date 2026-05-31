defmodule Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:override, 0)

  field(:pinned, 3,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.VersioningOverride.PinnedOverride,
    oneof: 0
  )

  field(:auto_upgrade, 4, type: :bool, json_name: "autoUpgrade", oneof: 0)

  field(:behavior, 1,
    type: Temporal.Protos.Temporal.Api.Enums.V1.VersioningBehavior,
    enum: true,
    deprecated: true
  )

  field(:deployment, 2,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.Deployment,
    deprecated: true
  )

  field(:pinned_version, 9, type: :string, json_name: "pinnedVersion", deprecated: true)
end
