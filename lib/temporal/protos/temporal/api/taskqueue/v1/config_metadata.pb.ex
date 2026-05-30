defmodule Temporal.Protos.Temporal.Api.Taskqueue.V1.ConfigMetadata do
  @moduledoc """
  Automatically generated module for ConfigMetadata

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`reason`** | `string` | Reason for why the config was set. |
  | 2 | **`update_identity`** | `string` | Identity of the last updater. |
  | 3 | **`update_time`** | `Google.Protobuf.Timestamp` | Time of the last update. |

  ### Additional Notes

    * `update_identity` (`string`): Identity of the last updater.
      Set by the request's identity field.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :reason, 1, type: :string
  field :update_identity, 2, type: :string, json_name: "updateIdentity"
  field :update_time, 3, type: Google.Protobuf.Timestamp, json_name: "updateTime"
end
