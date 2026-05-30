defmodule Temporal.Protos.Temporal.Api.Protocol.V1.Message do
  @moduledoc """
  (-- api-linter: core::0146::any=disabled
  aip.dev/not-precedent: We want runtime extensibility for the body field --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 5 | **`body`** | `Google.Protobuf.Any` | The opaque data carried by this message. The protocol type can be |
  | 4 | **`command_index`** | `int64` |  |
  | 3 | **`event_id`** | `int64` |  |
  | 1 | **`id`** | `string` | An ID for this specific message. |
  | 2 | **`protocol_instance_id`** | `string` | Identifies the specific instance of a protocol to which this message |

  ### Additional Notes

    * `body` (`Google.Protobuf.Any`): The opaque data carried by this message. The protocol type can be
      extracted from the package name of the message carried inside the Any.
    * `protocol_instance_id` (`string`): Identifies the specific instance of a protocol to which this message
      belongs.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :sequencing_id, 0

  field :id, 1, type: :string
  field :protocol_instance_id, 2, type: :string, json_name: "protocolInstanceId"
  field :event_id, 3, type: :int64, json_name: "eventId", oneof: 0
  field :command_index, 4, type: :int64, json_name: "commandIndex", oneof: 0
  field :body, 5, type: Google.Protobuf.Any
end
