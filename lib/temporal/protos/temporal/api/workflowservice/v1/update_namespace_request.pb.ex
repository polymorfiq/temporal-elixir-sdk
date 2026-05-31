defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateNamespaceRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)

  field(:update_info, 2,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo,
    json_name: "updateInfo"
  )

  field(:config, 3, type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig)

  field(:replication_config, 4,
    type: Temporal.Protos.Temporal.Api.Replication.V1.NamespaceReplicationConfig,
    json_name: "replicationConfig"
  )

  field(:security_token, 5, type: :string, json_name: "securityToken")
  field(:delete_bad_binary, 6, type: :string, json_name: "deleteBadBinary")
  field(:promote_namespace, 7, type: :bool, json_name: "promoteNamespace")
end
