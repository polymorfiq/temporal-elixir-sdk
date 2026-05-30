defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollNexusTaskQueueResponse do
  @moduledoc """
  Automatically generated module for PollNexusTaskQueueResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`poller_group_id`** | `string` | This poller group ID identifies the owner of the nexus task awaiting for synchronous |
  | 5 | **`poller_group_infos`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo` | The weighted list of poller groups IDs that client should use for future polls to this task |
  | 3 | **`poller_scaling_decision`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision` | Server-advised information the SDK may use to adjust its poller count. |
  | 2 | **`request`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Request` | Embedded request as translated from the incoming frontend request. |
  | 1 | **`task_token`** | `bytes` | An opaque unique identifier for this task for correlating a completion request the embedded request. |

  ### Additional Notes

    * `poller_group_id` (`string`): This poller group ID identifies the owner of the nexus task awaiting for synchronous
      response.
      Corresponding `RespondNexusTaskCompleted` and `RespondNexusTaskFailed` calls should pass this
      value for proper response routing.
    * `poller_group_infos` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo`): The weighted list of poller groups IDs that client should use for future polls to this task
      queue. Client is expected to:
        1. Maintain minimum number of pollers no less than the number of groups.
        2. Try to assign the next poll to a group without any pending polls,
        3. If every group has some pending polls, assign the next poll to a group randomly
          according to the weights.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :task_token, 1, type: :bytes, json_name: "taskToken"
  field :request, 2, type: Temporal.Protos.Temporal.Api.Nexus.V1.Request

  field :poller_scaling_decision, 3,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerScalingDecision,
    json_name: "pollerScalingDecision"

  field :poller_group_id, 4, type: :string, json_name: "pollerGroupId"

  field :poller_group_infos, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
end
