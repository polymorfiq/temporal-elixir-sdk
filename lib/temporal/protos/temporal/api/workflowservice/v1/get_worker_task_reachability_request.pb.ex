defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityRequest do
  @moduledoc """
  [cleanup-wv-pre-release]
  Deprecated. Use `DescribeTaskQueue`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`build_ids`** | `string` | Build ids to retrieve reachability for. An empty string will be interpreted as an unversioned worker. |
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`reachability`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability` | Type of reachability to query for. |
  | 3 | **`task_queues`** | `string` | Task queues to retrieve reachability for. Leave this empty to query for all task queues associated with given |

  ### Additional Notes

    * `build_ids` (`string`): Build ids to retrieve reachability for. An empty string will be interpreted as an unversioned worker.
      The number of build ids that can be queried in a single API call is limited.
      Open source users can adjust this limit by setting the server's dynamic config value for
      `limit.reachabilityQueryBuildIds` with the caveat that this call can strain the visibility store.
    * `reachability` (`Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability`): Type of reachability to query for.
      `TASK_REACHABILITY_NEW_WORKFLOWS` is always returned in the response.
      Use `TASK_REACHABILITY_EXISTING_WORKFLOWS` if your application needs to respond to queries on closed workflows.
      Otherwise, use `TASK_REACHABILITY_OPEN_WORKFLOWS`. Default is `TASK_REACHABILITY_EXISTING_WORKFLOWS` if left
      unspecified.
      See the TaskReachability docstring for information about each enum variant.
    * `task_queues` (`string`): Task queues to retrieve reachability for. Leave this empty to query for all task queues associated with given
      build ids in the namespace.
      Must specify at least one task queue if querying for an unversioned worker.
      The number of task queues that the server will fetch reachability information for is limited.
      See the `GetWorkerTaskReachabilityResponse` documentation for more information.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :build_ids, 2, repeated: true, type: :string, json_name: "buildIds"
  field :task_queues, 3, repeated: true, type: :string, json_name: "taskQueues"
  field :reachability, 4, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskReachability, enum: true
end
