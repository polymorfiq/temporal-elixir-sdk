defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.ClusterMetadata do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:cluster_name, 1, type: :string, json_name: "clusterName")
  field(:cluster_id, 2, type: :string, json_name: "clusterId")
  field(:address, 3, type: :string)
  field(:http_address, 7, type: :string, json_name: "httpAddress")
  field(:initial_failover_version, 4, type: :int64, json_name: "initialFailoverVersion")
  field(:history_shard_count, 5, type: :int32, json_name: "historyShardCount")
  field(:is_connection_enabled, 6, type: :bool, json_name: "isConnectionEnabled")
  field(:is_replication_enabled, 8, type: :bool, json_name: "isReplicationEnabled")
end
