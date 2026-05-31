defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskFailedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:task_token, 3, type: :bytes, json_name: "taskToken")
  field(:error, 4, type: Temporal.Protos.Temporal.Api.Nexus.V1.HandlerError, deprecated: true)
  field(:failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure)
  field(:poller_group_id, 6, type: :string, json_name: "pollerGroupId")
end
