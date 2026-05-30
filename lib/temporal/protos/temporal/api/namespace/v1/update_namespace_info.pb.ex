defmodule Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo do
  @moduledoc """
  Automatically generated module for UpdateNamespaceInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`data`** | `Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo.DataEntry` | A key-value map for any customized purpose. |
  | 1 | **`description`** | `string` |  |
  | 2 | **`owner_email`** | `string` |  |
  | 4 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState` | New namespace state, server will reject if transition is not allowed. |

  ### Additional Notes

    * `data` (`Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo.DataEntry`): A key-value map for any customized purpose.
      If data already exists on the namespace,
      this will merge with the existing key values.
    * `state` (`Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState`): New namespace state, server will reject if transition is not allowed.
      Allowed transitions are:
       Registered -> [ Deleted | Deprecated | Handover ]
       Handover -> [ Registered ]
      Default is NAMESPACE_STATE_UNSPECIFIED which is do not change state.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :description, 1, type: :string
  field :owner_email, 2, type: :string, json_name: "ownerEmail"

  field :data, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Namespace.V1.UpdateNamespaceInfo.DataEntry,
    map: true

  field :state, 4, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true
end
