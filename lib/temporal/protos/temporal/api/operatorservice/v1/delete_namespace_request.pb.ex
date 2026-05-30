defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNamespaceRequest do
  @moduledoc """
  Automatically generated module for DeleteNamespaceRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` | Only one of namespace or namespace_id must be specified to identify namespace. |
  | 3 | **`namespace_delete_delay`** | `Google.Protobuf.Duration` | If provided, the deletion of namespace info will be delayed for the given duration (0 means no delay). |
  | 2 | **`namespace_id`** | `string` |  |

  ### Additional Notes

    * `namespace_delete_delay` (`Google.Protobuf.Duration`): If provided, the deletion of namespace info will be delayed for the given duration (0 means no delay).
      If not provided, the default delay configured in the cluster will be used.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :namespace_id, 2, type: :string, json_name: "namespaceId"

  field :namespace_delete_delay, 3,
    type: Google.Protobuf.Duration,
    json_name: "namespaceDeleteDelay"
end
