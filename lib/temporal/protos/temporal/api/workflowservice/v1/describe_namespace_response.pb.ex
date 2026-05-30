defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse do
  @moduledoc """
  Automatically generated module for DescribeNamespaceResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`config`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig` |  |
  | 6 | **`failover_history`** | `Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus` | Contains the historical state of failover_versions for the cluster, truncated to contain only the last N |
  | 4 | **`failover_version`** | `int64` |  |
  | 5 | **`is_global_namespace`** | `bool` |  |
  | 1 | **`namespace_info`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo` |  |
  | 7 | **`poller_group_infos`** | `Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo` | The initial info that client should use for poller group assignment. This information is |
  | 3 | **`replication_config`** | `Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig` |  |

  ### Additional Notes

    * `failover_history` (`Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus`): Contains the historical state of failover_versions for the cluster, truncated to contain only the last N
      states to ensure that the list does not grow unbounded.
    * `poller_group_infos` (`Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo`): The initial info that client should use for poller group assignment. This information is
      updated through poll response. Client is supposed to use the info received in the latest
      poll response.

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

  field :failover_history, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus,
    json_name: "failoverHistory"

  field :poller_group_infos, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
end
