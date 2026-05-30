defmodule Temporal.Protos.Temporal.Api.Worker.V1.PluginInfo do
  @moduledoc """
  Automatically generated module for PluginInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`name`** | `string` | The name of the plugin, required. |
  | 2 | **`version`** | `string` | The version of the plugin, may be empty. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :name, 1, type: :string
  field :version, 2, type: :string
end
