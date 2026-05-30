defmodule Temporal.Protos.Temporal.Api.Update.V1.Acceptance do
  @moduledoc """
  An Update protocol message indicating that a Workflow Update has
  been accepted (i.e. passed the worker-side validation phase).

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`accepted_request`** | `Temporal.Protos.Temporal.Api.Update.V1.Request` |  |
  | 1 | **`accepted_request_message_id`** | `string` |  |
  | 2 | **`accepted_request_sequencing_event_id`** | `int64` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :accepted_request_message_id, 1, type: :string, json_name: "acceptedRequestMessageId"

  field :accepted_request_sequencing_event_id, 2,
    type: :int64,
    json_name: "acceptedRequestSequencingEventId"

  field :accepted_request, 3,
    type: Temporal.Protos.Temporal.Api.Update.V1.Request,
    json_name: "acceptedRequest"
end
