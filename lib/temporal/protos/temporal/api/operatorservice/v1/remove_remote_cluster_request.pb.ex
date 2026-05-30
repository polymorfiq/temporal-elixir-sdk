defmodule Temporal.Protos.Temporal.Api.Operatorservice.V1.RemoveRemoteClusterRequest do
  @moduledoc """
  Automatically generated module for RemoveRemoteClusterRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`cluster_name`** | `string` | Remote cluster name to be removed. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :cluster_name, 1, type: :string, json_name: "clusterName"
end
