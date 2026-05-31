defmodule Temporal.Protos.Temporal.Api.Version.V1.VersionInfo do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:current, 1, type: Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo)
  field(:recommended, 2, type: Temporal.Protos.Temporal.Api.Version.V1.ReleaseInfo)
  field(:instructions, 3, type: :string)
  field(:alerts, 4, repeated: true, type: Temporal.Protos.Temporal.Api.Version.V1.Alert)
  field(:last_update_time, 5, type: Google.Protobuf.Timestamp, json_name: "lastUpdateTime")
end
