defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetWorkerTaskReachabilityResponse do
  @moduledoc """
  [cleanup-wv-pre-release]
  Deprecated. Use `DescribeTaskQueue`.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`build_id_reachability`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability` | Task reachability, broken down by build id and then task queue. |

  ### Additional Notes

    * `build_id_reachability` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability`): Task reachability, broken down by build id and then task queue.
      When requesting a large number of task queues or all task queues associated with the given build ids in a
      namespace, all task queues will be listed in the response but some of them may not contain reachability
      information due to a server enforced limit. When reaching the limit, task queues that reachability information
      could not be retrieved for will be marked with a single TASK_REACHABILITY_UNSPECIFIED entry. The caller may issue
      another call to get the reachability for those task queues.

      Open source users can adjust this limit by setting the server's dynamic config value for
      `limit.reachabilityTaskQueueScan` with the caveat that this call can strain the visibility store.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :build_id_reachability, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.BuildIdReachability,
    json_name: "buildIdReachability"
end
