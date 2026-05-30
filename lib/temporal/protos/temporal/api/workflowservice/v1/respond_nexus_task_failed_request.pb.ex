defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RespondNexusTaskFailedRequest do
  @moduledoc """
  Automatically generated module for RespondNexusTaskFailedRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`error`** | `Temporal.Protos.Temporal.Api.Nexus.V1.HandlerError` | Deprecated. Use the failure field instead. |
  | 5 | **`failure`** | `Temporal.Protos.Temporal.Api.Failure.V1.Failure` | The error the handler failed with. Must contain a NexusHandlerFailureInfo object. |
  | 2 | **`identity`** | `string` | The identity of the client who initiated this request. |
  | 1 | **`namespace`** | `string` |  |
  | 6 | **`poller_group_id`** | `string` | Client must forward the poller_group_id received in PollNexusTaskQueueResponse for proper |
  | 3 | **`task_token`** | `bytes` | A unique identifier for this task. |

  ### Additional Notes

    * `poller_group_id` (`string`): Client must forward the poller_group_id received in PollNexusTaskQueueResponse for proper
      routing of the response.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :identity, 2, type: :string
  field :task_token, 3, type: :bytes, json_name: "taskToken"
  field :error, 4, type: Temporal.Protos.Temporal.Api.Nexus.V1.HandlerError, deprecated: true
  field :failure, 5, type: Temporal.Protos.Temporal.Api.Failure.V1.Failure
  field :poller_group_id, 6, type: :string, json_name: "pollerGroupId"
end
