defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskCompletedRequest do
  @moduledoc """
  Automatically generated module for RespondNexusTaskCompletedRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 5 | **`poller_group_id`** | `string` | Client must forward the poller_group_id received in PollNexusTaskQueueResponse for proper |
  | 4 | **`response`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Response` | Embedded response to be translated into a frontend response. |
  | 3 | **`task_token`** | `bytes` | A unique identifier for this task as received via a poll response. |

  ### Additional Notes

    * `poller_group_id` (`string`): Client must forward the poller_group_id received in PollNexusTaskQueueResponse for proper
      routing of the response.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string
  field :task_token, 3, type: :bytes, json_name: "taskToken"
  field :response, 4, type: Temporal.Protos.Temporal.Api.Nexus.V1.Response
  field :poller_group_id, 5, type: :string, json_name: "pollerGroupId"
end
