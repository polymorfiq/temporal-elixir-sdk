defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.DeleteNamespaceResponse do
  @moduledoc """
  Automatically generated module for DeleteNamespaceResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`deleted_namespace`** | `string` | Temporary namespace name that is used during reclaim resources step. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :deleted_namespace, 1, type: :string, json_name: "deletedNamespace"
end
