defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Capabilities do
  @moduledoc """
  Automatically generated module for Capabilities

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`async_update`** | `bool` |  |
  | 1 | **`eager_workflow_start`** | `bool` |  |
  | 9 | **`poller_autoscaling`** | `bool` | Whether scheduled workflows are supported on this namespace. This is only needed |
  | 5 | **`reported_problems_search_attribute`** | `bool` | A key-value map for any customized purpose. |
  | 7 | **`standalone_activities`** | `bool` | All capabilities the namespace supports. |
  | 11 | **`standalone_nexus_operation`** | `bool` |  |
  | 2 | **`sync_update`** | `bool` |  |
  | 10 | **`worker_commands`** | `bool` |  |
  | 4 | **`worker_heartbeats`** | `bool` |  |
  | 8 | **`worker_poll_complete_on_shutdown`** | `bool` | Namespace configured limits |
  | 6 | **`workflow_pause`** | `bool` |  |
  | 12 | **`workflow_update_callbacks`** | `bool` |  |

  ### Additional Notes

    * `poller_autoscaling` (`bool`): Whether scheduled workflows are supported on this namespace. This is only needed
      temporarily while the feature is experimental, so we can give it a high tag.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :eager_workflow_start, 1, type: :bool, json_name: "eagerWorkflowStart"
  field :sync_update, 2, type: :bool, json_name: "syncUpdate"
  field :async_update, 3, type: :bool, json_name: "asyncUpdate"
  field :worker_heartbeats, 4, type: :bool, json_name: "workerHeartbeats"

  field :reported_problems_search_attribute, 5,
    type: :bool,
    json_name: "reportedProblemsSearchAttribute"

  field :workflow_pause, 6, type: :bool, json_name: "workflowPause"
  field :standalone_activities, 7, type: :bool, json_name: "standaloneActivities"

  field :worker_poll_complete_on_shutdown, 8,
    type: :bool,
    json_name: "workerPollCompleteOnShutdown"

  field :poller_autoscaling, 9, type: :bool, json_name: "pollerAutoscaling"
  field :worker_commands, 10, type: :bool, json_name: "workerCommands"
  field :standalone_nexus_operation, 11, type: :bool, json_name: "standaloneNexusOperation"
  field :workflow_update_callbacks, 12, type: :bool, json_name: "workflowUpdateCallbacks"
end
