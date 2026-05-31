defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetCurrentDeploymentRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:series_name, 2, type: :string, json_name: "seriesName")
end
