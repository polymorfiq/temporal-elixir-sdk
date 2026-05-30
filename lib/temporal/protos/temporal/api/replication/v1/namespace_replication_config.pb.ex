defmodule Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig do
  @moduledoc """
  Automatically generated module for NamespaceReplicationConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`active_cluster_name`** | `string` |  |
  | 2 | **`clusters`** | `Temporal.Protos.Temporal.Api.Replication.V1.ClusterReplicationConfig` |  |
  | 3 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.ReplicationState` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :active_cluster_name, 1, type: :string, json_name: "activeClusterName"

  field :clusters, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Replication.V1.ClusterReplicationConfig

  field :state, 3, type: Temporal.Protos.Temporal.Api.Enums.V1.ReplicationState, enum: true
end
