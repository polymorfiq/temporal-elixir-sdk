defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ClusterMetadata do
  @moduledoc """
  Automatically generated module for ClusterMetadata

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`address`** | `string` | gRPC address. |
  | 2 | **`cluster_id`** | `string` | Id of the cluster. |
  | 1 | **`cluster_name`** | `string` | Name of the cluster name. |
  | 5 | **`history_shard_count`** | `int32` | History service shard number. |
  | 7 | **`http_address`** | `string` | HTTP address, if one exists. |
  | 4 | **`initial_failover_version`** | `int64` | A unique failover version across all connected clusters. |
  | 6 | **`is_connection_enabled`** | `bool` | A flag to indicate if a connection is active. |
  | 8 | **`is_replication_enabled`** | `bool` | A flag to indicate if replication is enabled. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cluster_name, 1, type: :string, json_name: "clusterName"
  field :cluster_id, 2, type: :string, json_name: "clusterId"
  field :address, 3, type: :string
  field :http_address, 7, type: :string, json_name: "httpAddress"
  field :initial_failover_version, 4, type: :int64, json_name: "initialFailoverVersion"
  field :history_shard_count, 5, type: :int32, json_name: "historyShardCount"
  field :is_connection_enabled, 6, type: :bool, json_name: "isConnectionEnabled"
  field :is_replication_enabled, 8, type: :bool, json_name: "isReplicationEnabled"
end
