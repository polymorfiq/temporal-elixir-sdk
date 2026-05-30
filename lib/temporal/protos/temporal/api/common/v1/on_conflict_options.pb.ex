defmodule Temporal.Protos.Temporal.Api.Common.V1.OnConflictOptions do
  @moduledoc """
  When starting an execution with a conflict policy that uses an existing execution and there is already an existing
  running execution, OnConflictOptions defines actions to be taken on the existing running execution.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`attach_completion_callbacks`** | `bool` | Attaches the completion callbacks to the running execution. |
  | 3 | **`attach_links`** | `bool` | Attaches the links to the running execution. |
  | 1 | **`attach_request_id`** | `bool` | Attaches the request ID to the running execution. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :attach_request_id, 1, type: :bool, json_name: "attachRequestId"
  field :attach_completion_callbacks, 2, type: :bool, json_name: "attachCompletionCallbacks"
  field :attach_links, 3, type: :bool, json_name: "attachLinks"
end
