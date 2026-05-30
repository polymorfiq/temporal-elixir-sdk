defmodule Temporal.Protos.Temporal.Api.Namespace.V1.NamespaceFilter do
  @moduledoc """
  Automatically generated module for NamespaceFilter

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`include_deleted`** | `bool` | By default namespaces in NAMESPACE_STATE_DELETED state are not included. |

  ### Additional Notes

    * `include_deleted` (`bool`): By default namespaces in NAMESPACE_STATE_DELETED state are not included.
      Setting include_deleted to true will include deleted namespaces.
      Note: Namespace is in NAMESPACE_STATE_DELETED state when it was deleted from the system but associated data is not deleted yet.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :include_deleted, 1, type: :bool, json_name: "includeDeleted"
end
