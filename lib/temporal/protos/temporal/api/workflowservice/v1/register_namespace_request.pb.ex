defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.RegisterNamespaceRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:namespace, 1, type: :string)
  field(:description, 2, type: :string)
  field(:owner_email, 3, type: :string, json_name: "ownerEmail")

  field(:workflow_execution_retention_period, 4,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionRetentionPeriod"
  )

  field(:clusters, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Replication.V1.ClusterReplicationConfig
  )

  field(:active_cluster_name, 6, type: :string, json_name: "activeClusterName")

  field(:data, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.RegisterNamespaceRequest.DataEntry,
    map: true
  )

  field(:security_token, 8, type: :string, json_name: "securityToken")
  field(:is_global_namespace, 9, type: :bool, json_name: "isGlobalNamespace")

  field(:history_archival_state, 10,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState,
    json_name: "historyArchivalState",
    enum: true
  )

  field(:history_archival_uri, 11, type: :string, json_name: "historyArchivalUri")

  field(:visibility_archival_state, 12,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState,
    json_name: "visibilityArchivalState",
    enum: true
  )

  field(:visibility_archival_uri, 13, type: :string, json_name: "visibilityArchivalUri")
end
