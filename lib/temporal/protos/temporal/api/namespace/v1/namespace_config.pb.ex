defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig do
  @moduledoc """
  Automatically generated module for NamespaceConfig

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`bad_binaries`** | `Temporal.Protos.Temporal.Api.Namespace.V1.BadBinaries` |  |
  | 7 | **`custom_search_attribute_aliases`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig.CustomSearchAttributeAliasesEntry` | Map from field name to alias. |
  | 3 | **`history_archival_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState` | If unspecified (ARCHIVAL_STATE_UNSPECIFIED) then default server configuration is used. |
  | 4 | **`history_archival_uri`** | `string` |  |
  | 5 | **`visibility_archival_state`** | `Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState` | If unspecified (ARCHIVAL_STATE_UNSPECIFIED) then default server configuration is used. |
  | 6 | **`visibility_archival_uri`** | `string` |  |
  | 1 | **`workflow_execution_retention_ttl`** | `Google.Protobuf.Duration` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :workflow_execution_retention_ttl, 1,
    type: Google.Protobuf.Duration,
    json_name: "workflowExecutionRetentionTtl"

  field :bad_binaries, 2,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.BadBinaries,
    json_name: "badBinaries"

  field :history_archival_state, 3,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState,
    json_name: "historyArchivalState",
    enum: true

  field :history_archival_uri, 4, type: :string, json_name: "historyArchivalUri"

  field :visibility_archival_state, 5,
    type: Temporal.Protos.Temporal.Api.Enums.V1.ArchivalState,
    json_name: "visibilityArchivalState",
    enum: true

  field :visibility_archival_uri, 6, type: :string, json_name: "visibilityArchivalUri"

  field :custom_search_attribute_aliases, 7,
    repeated: true,
    type:
      Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceConfig.CustomSearchAttributeAliasesEntry,
    json_name: "customSearchAttributeAliases",
    map: true
end
