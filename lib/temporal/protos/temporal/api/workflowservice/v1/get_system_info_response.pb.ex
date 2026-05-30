defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse do
  @moduledoc """
  Automatically generated module for GetSystemInfoResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`capabilities`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse.Capabilities` | All capabilities the system supports. |
  | 1 | **`server_version`** | `string` | Version of the server. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :server_version, 1, type: :string, json_name: "serverVersion"

  field :capabilities, 2,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.GetSystemInfoResponse.Capabilities
end
