defmodule Temporal.Protos.Temporal.Api.Version.V1.VersionInfo do
  @moduledoc """
  VersionInfo contains details about current and recommended release versions as well as alerts and upgrade instructions.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 4 | **`alerts`** | `Temporal.Protos.Temporal.Api.Version.V1.Alert` |  |
  | 1 | **`current`** | `Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo` |  |
  | 3 | **`instructions`** | `string` |  |
  | 5 | **`last_update_time`** | `Google.Protobuf.Timestamp` |  |
  | 2 | **`recommended`** | `Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :current, 1, type: Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo
  field :recommended, 2, type: Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo
  field :instructions, 3, type: :string
  field :alerts, 4, repeated: true, type: Temporal.Protos.Temporal.Api.Version.V1.Alert
  field :last_update_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastUpdateTime"
end
