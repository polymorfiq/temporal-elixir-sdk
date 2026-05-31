defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StopBatchOperationRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:job_id, 2, type: :string, json_name: "jobId")
  field(:reason, 3, type: :string)
  field(:identity, 4, type: :string)
end
