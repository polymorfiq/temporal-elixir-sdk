defmodule Temporal.Protos.Temporal.Api.Command.V1.ProtocolMessageCommandAttributes do
  @moduledoc """
  Automatically generated module for ProtocolMessageCommandAttributes

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`message_id`** | `string` | The message ID of the message to which this command is a pointer. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :message_id, 1, type: :string, json_name: "messageId"
end
