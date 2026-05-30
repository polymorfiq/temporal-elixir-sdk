defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeprecateNamespaceRequest do
  @moduledoc """
  Deprecated.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 2 | **`security_token`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :security_token, 2, type: :string, json_name: "securityToken"
end
