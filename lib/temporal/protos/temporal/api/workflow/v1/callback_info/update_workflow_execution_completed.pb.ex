defmodule Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo.UpdateWorkflowExecutionCompleted do
  @moduledoc """
  CallbackInfo contains the state of an attached workflow callback.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`update_id`** | `string` | Information on how this callback should be invoked (e.g. its URL and type). |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :update_id, 1, type: :string, json_name: "updateId"
end
