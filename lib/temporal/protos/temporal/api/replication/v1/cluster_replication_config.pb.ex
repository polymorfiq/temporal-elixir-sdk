defmodule Temporal.Protos.Temporal.Api.Replication.V1.ClusterReplicationConfig do
  @moduledoc """
  Automatically generated module for ClusterReplicationConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cluster_name`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cluster_name, 1, type: :string, json_name: "clusterName"
end
