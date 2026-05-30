defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetClusterInfoResponse.SupportedClientsEntry do
  @moduledoc """
  GetClusterInfoResponse contains information about Temporal cluster.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`key`** | `string` | Key is client name i.e "temporal-go", "temporal-java", or "temporal-cli". |
  | 2 | **`value`** | `string` |  |

  ### Additional Notes

    * `key` (`string`): Key is client name i.e "temporal-go", "temporal-java", or "temporal-cli".
      Value is ranges of supported versions of this client i.e ">1.1.1 <=1.4.0 || ^5.0.0".

  """
  use Protobuf, map: true, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :key, 1, type: :string
  field :value, 2, type: :string
end
