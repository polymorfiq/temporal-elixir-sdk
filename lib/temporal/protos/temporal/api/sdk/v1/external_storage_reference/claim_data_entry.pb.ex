defmodule Temporal.Protos.Temporal.Api.Sdk.V1.ExternalStorageReference.ClaimDataEntry do
  @moduledoc """
  ExternalStorageReference identifies a payload stored in an external storage system.
  It is used as a claim-check token, allowing the actual payload data to be retrieved
  from the named driver using the provided claim data.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | The name of the storage driver responsible for retrieving the payload. |
  | 2 | **`value`** | `string` | Driver-specific key-value pairs that identify and provide access to the stored payload. |

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
