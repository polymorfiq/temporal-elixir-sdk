defmodule Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:failover_time, 1, type: Google.Protobuf.Timestamp, json_name: "failoverTime")
  field(:failover_version, 2, type: :int64, json_name: "failoverVersion")
end
