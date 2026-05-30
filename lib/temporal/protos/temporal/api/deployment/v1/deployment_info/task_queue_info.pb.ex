defmodule Temporal.Protos.Temporal.Api.Deployment.V1.DeploymentInfo.TaskQueueInfo do
  @moduledoc """
  `DeploymentInfo` holds information about a deployment. Deployment information is tracked
  automatically by server as soon as the first poll from that deployment reaches the server. There
  can be multiple task queue workers in a single deployment which are listed in this message.
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`first_poller_time`** | `Google.Protobuf.Timestamp` |  |
  | 1 | **`name`** | `string` |  |
  | 2 | **`type`** | `Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :type, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.TaskQueueType, enum: true
  field :first_poller_time, 3, type: Google.Protobuf.Timestamp, json_name: "firstPollerTime"
end
