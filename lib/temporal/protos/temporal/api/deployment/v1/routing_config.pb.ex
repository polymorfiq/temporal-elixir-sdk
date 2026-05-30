defmodule Temporal.Protos.Temporal.Api.Deployment.V1.RoutingConfig do
  @moduledoc """
  Automatically generated module for RoutingConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`current_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | Specifies which Deployment Version should receive new workflow executions and tasks of |
  | 1 | **`current_version`** | `string` | Deprecated. Use `current_deployment_version`. |
  | 4 | **`current_version_changed_time`** | `Google.Protobuf.Timestamp` | Last time current version was changed. |
  | 9 | **`ramping_deployment_version`** | `Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion` | When ramp percentage is non-zero, that portion of traffic is shifted from the Current Version to the Ramping Version. |
  | 2 | **`ramping_version`** | `string` | Deprecated. Use `ramping_deployment_version`. |
  | 5 | **`ramping_version_changed_time`** | `Google.Protobuf.Timestamp` | Last time ramping version was changed. Not updated if only the ramp percentage changes. |
  | 3 | **`ramping_version_percentage`** | `float` | Percentage of tasks that are routed to the Ramping Version instead of the Current Version. |
  | 6 | **`ramping_version_percentage_changed_time`** | `Google.Protobuf.Timestamp` | Last time ramping version percentage was changed. |
  | 10 | **`revision_number`** | `int64` | Monotonically increasing value which is incremented on every mutation |

  ### Additional Notes

    * `current_deployment_version` (`Temporal.Protos.Temporal.Api.Deployment.V1.WorkerDeploymentVersion`): Specifies which Deployment Version should receive new workflow executions and tasks of
      existing unversioned or AutoUpgrade workflows.
      Nil value means no Version in this Deployment (except Ramping Version, if present) receives traffic other than tasks of previously Pinned workflows. In absence of a Current Version, remaining traffic after any ramp (if set)  goes to unversioned workers (those with `UNVERSIONED` (or unspecified) `WorkerVersioningMode`.).
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
    * `ramping_version_percentage_changed_time` (`Google.Protobuf.Timestamp`): Last time ramping version percentage was changed.
      If ramping version is changed, this is also updated, even if the percentage stays the same.
    * `revision_number` (`int64`): Monotonically increasing value which is incremented on every mutation
      to any field of this message to achieve eventual consistency between task queues and their partitions.

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

  field :current_version_changed_time, 4,
    type: Google.Protobuf.Timestamp,
    json_name: "currentVersionChangedTime"

  field :ramping_version_changed_time, 5,
    type: Google.Protobuf.Timestamp,
    json_name: "rampingVersionChangedTime"

  field :ramping_version_percentage_changed_time, 6,
    type: Google.Protobuf.Timestamp,
    json_name: "rampingVersionPercentageChangedTime"

  field :revision_number, 10, type: :int64, json_name: "revisionNumber"
end
