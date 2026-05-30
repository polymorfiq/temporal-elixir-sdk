defmodule Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionPauseInfo do
  @moduledoc """
  WorkflowExecutionPauseInfo contains the information about a workflow execution pause.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`identity`** | `string` | The identity of the client who paused the workflow execution. |
  | 2 | **`paused_time`** | `Google.Protobuf.Timestamp` | The time when the workflow execution was paused. |
  | 3 | **`reason`** | `string` | The reason for pausing the workflow execution. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :identity, 1, type: :string
  field :paused_time, 2, type: Google.Protobuf.Timestamp, json_name: "pausedTime"
  field :reason, 3, type: :string
end
