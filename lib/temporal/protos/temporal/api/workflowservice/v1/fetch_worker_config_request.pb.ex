defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.FetchWorkerConfigRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:reason, 3, type: :string)
  field(:selector, 6, type: Temporal.Protos.Temporal.Api.Common.V1.WorkerSelector)
  field(:resource_id, 7, type: :string, json_name: "resourceId")
end
