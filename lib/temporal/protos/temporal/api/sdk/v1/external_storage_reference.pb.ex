defmodule Temporal.Protos.Temporal.Api.Sdk.V1.ExternalStorageReference do
  @moduledoc """
  ExternalStorageReference identifies a payload stored in an external storage system.
  It is used as a claim-check token, allowing the actual payload data to be retrieved
  from the named driver using the provided claim data.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`claim_data`** | `Temporal.Protos.Temporal.Api.Sdk.V1.ExternalStorageReference.ClaimDataEntry` | Driver-specific key-value pairs that identify and provide access to the stored payload. |
  | 1 | **`driver_name`** | `string` | The name of the storage driver responsible for retrieving the payload. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :driver_name, 1, type: :string, json_name: "driverName"

  field :claim_data, 2,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Sdk.V1.ExternalStorageReference.ClaimDataEntry,
    json_name: "claimData",
    map: true
end
