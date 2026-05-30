defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateNamespaceResponse do
  @moduledoc """
  Automatically generated module for UpdateNamespaceResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`config`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig` |  |
  | 4 | **`failover_version`** | `int64` |  |
  | 5 | **`is_global_namespace`** | `bool` |  |
  | 1 | **`namespace_info`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo` |  |
  | 3 | **`replication_config`** | `Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace_info, 1,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo,
    json_name: "namespaceInfo"

  field :config, 2, type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig

  field :replication_config, 3,
    type: Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig,
    json_name: "replicationConfig"

  field :failover_version, 4, type: :int64, json_name: "failoverVersion"
  field :is_global_namespace, 5, type: :bool, json_name: "isGlobalNamespace"
end
