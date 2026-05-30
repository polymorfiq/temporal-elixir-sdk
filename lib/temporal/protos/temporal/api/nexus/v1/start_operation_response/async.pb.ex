defmodule Temporal.Protos.Temporal.Api.Nexus.V1.StartOperationResponse.Async do
  @moduledoc """
  Response variant for StartOperationRequest.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`links`** | `Temporal.Protos.Temporal.Api.Nexus.V1.Link` |  |
  | 1 | **`operation_id`** | `string` |  |
  | 3 | **`operation_token`** | `string` | The operation completed unsuccessfully (failed or canceled). |

  ### Additional Notes

    * `operation_token` (`string`): The operation completed unsuccessfully (failed or canceled).
      Deprecated. Use the failure variant instead.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :operation_id, 1, type: :string, json_name: "operationId", deprecated: true
  field :links, 2, repeated: true, type: Temporal.Protos.Temporal.Api.Nexus.V1.Link
  field :operation_token, 3, type: :string, json_name: "operationToken"
end
