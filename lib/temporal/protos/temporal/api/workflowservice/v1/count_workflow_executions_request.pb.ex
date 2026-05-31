defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.CountWorkflowExecutionsRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:query, 2, type: :string)
end
