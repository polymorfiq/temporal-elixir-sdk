defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NotFoundFailure do
  @moduledoc """
  Automatically generated module for NotFoundFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`active_cluster`** | `string` |  |
  | 1 | **`current_cluster`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :current_cluster, 1, type: :string, json_name: "currentCluster"
  field :active_cluster, 2, type: :string, json_name: "activeCluster"
end
