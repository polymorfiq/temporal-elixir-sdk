defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NamespaceInvalidStateFailure do
  @moduledoc """
  Automatically generated module for NamespaceInvalidStateFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`allowed_states`** | `Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState` | Allowed namespace states for requested operation. |
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`state`** | `Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState` | Current state of the requested namespace. |

  ### Additional Notes

    * `allowed_states` (`Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState`): Allowed namespace states for requested operation.
      For example NAMESPACE_STATE_DELETED is forbidden for most operations but allowed for DescribeNamespace.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :state, 2, type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState, enum: true

  field :allowed_states, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Enums.V1.NamespaceState,
    json_name: "allowedStates",
    enum: true
end
