defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:operations, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationRequest.Operation
  )

  field(:resource_id, 3, type: :string, json_name: "resourceId")
end
