defmodule Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus do
  @moduledoc """
  Represents a historical replication status of a Namespace

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`failover_time`** | `Google.Protobuf.Timestamp` | Timestamp when the Cluster switched to the following failover_version |
  | 2 | **`failover_version`** | `int64` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :failover_time, 1, type: Google.Protobuf.Timestamp, json_name: "failoverTime"
  field :failover_version, 2, type: :int64, json_name: "failoverVersion"
end
