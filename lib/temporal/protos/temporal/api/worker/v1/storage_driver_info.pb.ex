defmodule Temporal.Protos.Temporal.Api.Worker.V1.StorageDriverInfo do
  @moduledoc """
  Automatically generated module for StorageDriverInfo

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`type`** | `string` | The type of the driver, required. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :type, 1, type: :string
end
