defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo do
  @moduledoc """
  Automatically generated module for NamespaceInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 7 | **`capabilities`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Capabilities` | All capabilities the namespace supports. |
  | 5 | **`data`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.DataEntry` | A key-value map for any customized purpose. |
  | 3 | **`description`** | `string` |  |
  | 6 | **`id`** | `string` |  |
  | 8 | **`limits`** | `Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Limits` | Namespace configured limits |
  | 1 | **`name`** | `string` |  |
  | 4 | **`owner_email`** | `string` |  |
  | 2 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState` |  |
  | 100 | **`supports_schedules`** | `bool` | Whether scheduled workflows are supported on this namespace. This is only needed |

  ### Additional Notes

    * `supports_schedules` (`bool`): Whether scheduled workflows are supported on this namespace. This is only needed
      temporarily while the feature is experimental, so we can give it a high tag.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true
  field :description, 3, type: :string
  field :owner_email, 4, type: :string, json_name: "ownerEmail"

  field :data, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.DataEntry,
    map: true

  field :id, 6, type: :string

  field :capabilities, 7,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Capabilities

  field :limits, 8, type: Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceInfo.Limits
  field :supports_schedules, 100, type: :bool, json_name: "supportsSchedules"
end
