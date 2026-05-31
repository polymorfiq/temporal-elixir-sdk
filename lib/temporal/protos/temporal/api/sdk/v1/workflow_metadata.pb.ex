defmodule Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:definition, 1, type: Temporal.Protos.Temporal.Api.Sdk.V1.WorkflowDefinition)
  field(:current_details, 2, type: :string, json_name: "currentDetails")
end
