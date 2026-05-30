defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.TaskQueueVersioningInfo do
  @moduledoc """
  Automatically generated module for TaskQueueVersioningInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`current_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Specifies which Deployment Version should receive new workflow executions and tasks of |
  | 1 | **`current_version`** | `string` | Deprecated. Use `current_deployment_version`. |
  | 9 | **`ramping_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | When ramp percentage is non-zero, that portion of traffic is shifted from the Current Version to the Ramping Version. |
  | 2 | **`ramping_version`** | `string` | Deprecated. Use `ramping_deployment_version`. |
  | 3 | **`ramping_version_percentage`** | `float` | Percentage of tasks that are routed to the Ramping Version instead of the Current Version. |
  | 4 | **`update_time`** | `Google.Protobuf.Timestamp` | Last time versioning information of this Task Queue changed. |

  ### Additional Notes

    * `current_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): Specifies which Deployment Version should receive new workflow executions and tasks of
      existing unversioned or AutoUpgrade workflows.
      Nil value represents all the unversioned workers (those with `UNVERSIONED` (or unspecified) `WorkerVersioningMode`.)
      Note: Current Version is overridden by the Ramping Version for a portion of traffic when ramp percentage
      is non-zero (see `ramping_deployment_version` and `ramping_version_percentage`).
    * `ramping_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): When ramp percentage is non-zero, that portion of traffic is shifted from the Current Version to the Ramping Version.
      Must always be different from `current_deployment_version` unless both are nil.
      Nil value represents all the unversioned workers (those with `UNVERSIONED` (or unspecified) `WorkerVersioningMode`.)
      Note that it is possible to ramp from one Version to another Version, or from unversioned
      workers to a particular Version, or from a particular Version to unversioned workers.
    * `ramping_version_percentage` (`float`): Percentage of tasks that are routed to the Ramping Version instead of the Current Version.
      Valid range: [0, 100]. A 100% value means the Ramping Version is receiving full traffic but
      not yet "promoted" to be the Current Version, likely due to pending validations.
      A 0% value means the Ramping Version is receiving no traffic.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :current_deployment_version, 7,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "currentDeploymentVersion"

  field :current_version, 1, type: :string, json_name: "currentVersion", deprecated: true

  field :ramping_deployment_version, 9,
    type: Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion,
    json_name: "rampingDeploymentVersion"

  field :ramping_version, 2, type: :string, json_name: "rampingVersion", deprecated: true
  field :ramping_version_percentage, 3, type: :float, json_name: "rampingVersionPercentage"
  field :update_time, 4, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end
