defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.ConfigMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:reason, 1, type: :string)
  field(:update_identity, 2, type: :string, json_name: "updateIdentity")
  field(:update_time, 3, type: Google.Protobuf.Timestamp, json_name: "updateTime")
end
