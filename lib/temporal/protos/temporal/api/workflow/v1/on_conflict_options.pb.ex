defmodule Temporal.Protos.Temporal.Api.Workflow.V1.OnConflictOptions do
  @moduledoc """
  When StartWorkflowExecution uses the conflict policy WORKFLOW_ID_CONFLICT_POLICY_USE_EXISTING and
  there is already an existing running workflow, OnConflictOptions defines actions to be taken on
  the existing running workflow. In this case, it will create a WorkflowExecutionOptionsUpdatedEvent
  history event in the running workflow with the changes requested in this object.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`attach_completion_callbacks`** | `bool` | Attaches the completion callbacks to the running workflow. |
  | 3 | **`attach_links`** | `bool` | Attaches the links to the WorkflowExecutionOptionsUpdatedEvent history event. |
  | 1 | **`attach_request_id`** | `bool` | Attaches the request ID to the running workflow. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :attach_request_id, 1, type: :bool, json_name: "attachRequestId"
  field :attach_completion_callbacks, 2, type: :bool, json_name: "attachCompletionCallbacks"
  field :attach_links, 3, type: :bool, json_name: "attachLinks"
end
