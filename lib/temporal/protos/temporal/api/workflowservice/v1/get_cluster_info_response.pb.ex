defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse do
  @moduledoc """
  GetClusterInfoResponse contains information about Temporal cluster.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`cluster_id`** | `string` |  |
  | 5 | **`cluster_name`** | `string` |  |
  | 10 | **`failover_version_increment`** | `int64` |  |
  | 6 | **`history_shard_count`** | `int32` |  |
  | 9 | **`initial_failover_version`** | `int64` |  |
  | 7 | **`persistence_store`** | `string` |  |
  | 2 | **`server_version`** | `string` |  |
  | 1 | **`supported_clients`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse.SupportedClientsEntry` | Key is client name i.e "temporal-go", "temporal-java", or "temporal-cli". |
  | 4 | **`version_info`** | `Temporal.Protos.Temporal.Api.Version.V1.VersionInfo` |  |
  | 8 | **`visibility_store`** | `string` |  |

  ### Additional Notes

    * `supported_clients` (`Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse.SupportedClientsEntry`): Key is client name i.e "temporal-go", "temporal-java", or "temporal-cli".
      Value is ranges of supported versions of this client i.e ">1.1.1 <=1.4.0 || ^5.0.0".

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :supported_clients, 1,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse.SupportedClientsEntry,
    json_name: "supportedClients",
    map: true

  field :server_version, 2, type: :string, json_name: "serverVersion"
  field :cluster_id, 3, type: :string, json_name: "clusterId"

  field :version_info, 4,
    type: Temporal.Protos.Temporal.Api.Version.V1.VersionInfo,
    json_name: "versionInfo"

  field :cluster_name, 5, type: :string, json_name: "clusterName"
  field :history_shard_count, 6, type: :int32, json_name: "historyShardCount"
  field :persistence_store, 7, type: :string, json_name: "persistenceStore"
  field :visibility_store, 8, type: :string, json_name: "visibilityStore"
  field :initial_failover_version, 9, type: :int64, json_name: "initialFailoverVersion"
  field :failover_version_increment, 10, type: :int64, json_name: "failoverVersionIncrement"
end
