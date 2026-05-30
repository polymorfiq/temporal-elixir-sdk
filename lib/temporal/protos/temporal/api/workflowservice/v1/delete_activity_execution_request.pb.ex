defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DeleteActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for DeleteActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`activity_id`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`run_id`** | `string` | Activity run ID, targets the latest run if run_id is empty. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :activity_id, 2, type: :string, json_name: "activityId"
  field :run_id, 3, type: :string, json_name: "runId"
end
