defmodule Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo do
  @moduledoc """
  Information about workflow drainage to help the user determine when it is safe
  to decommission a Version. Not present while version is current or ramping.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`last_changed_time`** | `Google.Protobuf.Timestamp` | Last time the drainage status changed. |
  | 3 | **`last_checked_time`** | `Google.Protobuf.Timestamp` | Last time the system checked for drainage of this version. |
  | 1 | **`status`** | `Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus` | Set to DRAINING when the version first stops accepting new executions (is no longer current or ramping). |

  ### Additional Notes

    * `status` (`Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus`): Set to DRAINING when the version first stops accepting new executions (is no longer current or ramping).
      Set to DRAINED when no more open pinned workflows exist on this version.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :status, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus, enum: true
  field :last_changed_time, 2, type: Google.Protobuf.Timestamp, json_name: "lastChangedTime"
  field :last_checked_time, 3, type: Google.Protobuf.Timestamp, json_name: "lastCheckedTime"
end
