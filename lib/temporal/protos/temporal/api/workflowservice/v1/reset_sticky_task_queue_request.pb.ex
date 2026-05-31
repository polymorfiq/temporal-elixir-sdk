defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ResetStickyTaskQueueRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:execution, 2, type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution)
end
