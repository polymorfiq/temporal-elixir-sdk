defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.SetWorkerDeploymentCurrentVersionRequest do
  @moduledoc """
  Set/unset the Current Version of a Worker Deployment.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 9 | **`allow_no_pollers`** | `bool` | Optional. By default this request will be rejected if no pollers have been seen for the proposed |
  | 7 | **`build_id`** | `string` | The build id of the Version that you want to set as Current. |
  | 4 | **`conflict_token`** | `bytes` | Optional. This can be the value of conflict_token from a Describe, or another Worker |
  | 2 | **`deployment_name`** | `string` |  |
  | 5 | **`identity`** | `string` | Optional. The identity of the client who initiated this request. |
  | 6 | **`ignore_missing_task_queues`** | `bool` | Optional. By default this request would be rejected if not all the expected Task Queues are |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`version`** | `string` | Deprecated. Use `build_id`. |

  ### Additional Notes

    * `allow_no_pollers` (`bool`): Optional. By default this request will be rejected if no pollers have been seen for the proposed
      Current Version, in order to protect users from routing tasks to pollers that do not exist, leading
      to possible timeouts. Pass `true` here to bypass this protection.
    * `build_id` (`string`): The build id of the Version that you want to set as Current.
      Pass an empty value to set the Current Version to nil.
      A nil Current Version represents all the unversioned workers (those with `UNVERSIONED` (or unspecified) `WorkerVersioningMode`.)
    * `conflict_token` (`bytes`): Optional. This can be the value of conflict_token from a Describe, or another Worker
      Deployment API. Passing a non-nil conflict token will cause this request to fail if the
      Deployment's configuration has been modified between the API call that generated the
      token and this one.
    * `ignore_missing_task_queues` (`bool`): Optional. By default this request would be rejected if not all the expected Task Queues are
      being polled by the new Version, to protect against accidental removal of Task Queues, or
      worker health issues. Pass `true` here to bypass this protection.
      The set of expected Task Queues is the set of all the Task Queues that were ever poller by
      the existing Current Version of the Deployment, with the following exclusions:
        - Task Queues that are not used anymore (inferred by having empty backlog and a task
          add_rate of 0.)
        - Task Queues that are moved to another Worker Deployment (inferred by the Task Queue
          having a different Current Version than the Current Version of this deployment.)
      WARNING: Do not set this flag unless you are sure that the missing task queue pollers are not
      needed. If the request is unexpectedly rejected due to missing pollers, then that means the
      pollers have not reached to the server yet. Only set this if you expect those pollers to
      never arrive.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :deployment_name, 2, type: :string, json_name: "deploymentName"
  field :version, 3, type: :string, deprecated: true
  field :build_id, 7, type: :string, json_name: "buildId"
  field :conflict_token, 4, type: :bytes, json_name: "conflictToken"
  field :identity, 5, type: :string
  field :ignore_missing_task_queues, 6, type: :bool, json_name: "ignoreMissingTaskQueues"
  field :allow_no_pollers, 9, type: :bool, json_name: "allowNoPollers"
end
