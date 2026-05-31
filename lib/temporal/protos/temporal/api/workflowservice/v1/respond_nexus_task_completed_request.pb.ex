defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskCompletedRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:identity, 2, type: :string)
  field(:task_token, 3, type: :bytes, json_name: "taskToken")
  field(:response, 4, type: Temporal.Protos.Temporal.Api.Nexus.V1.Response)
  field(:poller_group_id, 5, type: :string, json_name: "pollerGroupId")
end
