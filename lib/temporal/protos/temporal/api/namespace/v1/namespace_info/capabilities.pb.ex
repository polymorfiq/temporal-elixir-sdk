defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Capabilities do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:eager_workflow_start, 1, type: :bool, json_name: "eagerWorkflowStart")
  field(:sync_update, 2, type: :bool, json_name: "syncUpdate")
  field(:async_update, 3, type: :bool, json_name: "asyncUpdate")
  field(:worker_heartbeats, 4, type: :bool, json_name: "workerHeartbeats")

  field(:reported_problems_search_attribute, 5,
    type: :bool,
    json_name: "reportedProblemsSearchAttribute"
  )

  field(:workflow_pause, 6, type: :bool, json_name: "workflowPause")
  field(:standalone_activities, 7, type: :bool, json_name: "standaloneActivities")

  field(:worker_poll_complete_on_shutdown, 8,
    type: :bool,
    json_name: "workerPollCompleteOnShutdown"
  )

  field(:poller_autoscaling, 9, type: :bool, json_name: "pollerAutoscaling")
  field(:worker_commands, 10, type: :bool, json_name: "workerCommands")
  field(:standalone_nexus_operation, 11, type: :bool, json_name: "standaloneNexusOperation")
  field(:workflow_update_callbacks, 12, type: :bool, json_name: "workflowUpdateCallbacks")
end
