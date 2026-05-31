defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:task_token, 1, type: :bytes, json_name: "taskToken")
  field(:request, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Request)

  field(:poller_scaling_decision, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision,
    json_name: "pollerScalingDecision"
  )

  field(:poller_group_id, 4, type: :string, json_name: "pollerGroupId")

  field(:poller_group_infos, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
  )
end
