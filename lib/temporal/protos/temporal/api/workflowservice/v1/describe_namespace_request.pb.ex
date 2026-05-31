defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:id, 2, type: :string)
  field(:weak_consistency, 3, type: :bool, json_name: "weakConsistency")
end
