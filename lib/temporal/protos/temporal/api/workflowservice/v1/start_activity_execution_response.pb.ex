defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartActivityExecutionResponse do
  @moduledoc """
  Automatically generated module for StartActivityExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`link`** | `Temporal.Protos.Temporal.Api.Common.V1.Link` | Link to the started activity. |
  | 1 | **`run_id`** | `string` | The run ID of the activity that was started - or used (via ACTIVITY_ID_CONFLICT_POLICY_USE_EXISTING). |
  | 2 | **`started`** | `bool` | If true, a new activity was started. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :started, 2, type: :bool
  field :link, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Link
end
