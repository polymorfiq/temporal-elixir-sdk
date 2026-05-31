defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeNamespaceResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace_info, 1,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo,
    json_name: "namespaceInfo"
  )

  field(:config, 2, type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig)

  field(:replication_config, 3,
    type: Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig,
    json_name: "replicationConfig"
  )

  field(:failover_version, 4, type: :int64, json_name: "failoverVersion")
  field(:is_global_namespace, 5, type: :bool, json_name: "isGlobalNamespace")

  field(:failover_history, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Replication.V1.FailoverStatus,
    json_name: "failoverHistory"
  )

  field(:poller_group_infos, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Taskqueue.V1.PollerGroupInfo,
    json_name: "pollerGroupInfos"
  )
end
