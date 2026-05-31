defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowDefinition do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:type, 1, type: :string)

  field(:query_definitions, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "queryDefinitions"
  )

  field(:signal_definitions, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "signalDefinitions"
  )

  field(:update_definitions, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowInteractionDefinition,
    json_name: "updateDefinitions"
  )
end
