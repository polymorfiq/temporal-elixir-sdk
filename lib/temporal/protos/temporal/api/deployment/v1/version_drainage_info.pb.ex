defmodule Temporal.Protos.Temporal.Api.Deployment.V1.VersionDrainageInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:status, 1, type: Temporal.Protos.Temporal.Api.Enums.V1.VersionDrainageStatus, enum: true)
  field(:last_changed_time, 2, type: Google.Protobuf.Timestamp, json_name: "lastChangedTime")
  field(:last_checked_time, 3, type: Google.Protobuf.Timestamp, json_name: "lastCheckedTime")
end
