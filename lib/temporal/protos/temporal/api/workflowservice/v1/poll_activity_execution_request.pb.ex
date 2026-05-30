defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for PollActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`activity_id`** | `string` |  |
  | 1 | **`namespace`** | `string` |  |
  | 3 | **`run_id`** | `string` | Activity run ID. If empty the request targets the latest run. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :activity_id, 2, type: :string, json_name: "activityId"
  field :run_id, 3, type: :string, json_name: "runId"
end
