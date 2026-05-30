defmodule Temporal.Protos.Temporal.Api.History.V1.WorkflowExecutionPausedEventAttributes do
  @moduledoc """
  Attributes for an event marking that a workflow execution was paused.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the client who paused the workflow execution. |
  | 2 | **`reason`** | `string` | The reason for pausing the workflow execution. |
  | 3 | **`request_id`** | `string` | The request ID of the request that paused the workflow execution. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
  field :reason, 2, type: :string
  field :request_id, 3, type: :string, json_name: "requestId"
end
