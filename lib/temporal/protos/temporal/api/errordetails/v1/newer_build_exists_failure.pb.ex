defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.NewerBuildExistsFailure do
  @moduledoc """
  Automatically generated module for NewerBuildExistsFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`default_build_id`** | `string` | The current default compatible build ID which will receive tasks |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :default_build_id, 1, type: :string, json_name: "defaultBuildId"
end
