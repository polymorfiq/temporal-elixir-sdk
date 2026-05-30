defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.TerminateActivityExecutionRequest do
  @moduledoc """
  Automatically generated module for TerminateActivityExecutionRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`activity_id`** | `string` |  |
  | 4 | **`identity`** | `string` | The identity of the worker/client. |
  | 1 | **`namespace`** | `string` |  |
  | 6 | **`reason`** | `string` | Reason for requesting the termination, recorded in in the activity's result failure outcome. |
  | 5 | **`request_id`** | `string` | Used to de-dupe termination requests. |
  | 3 | **`run_id`** | `string` | Activity run ID, targets the latest run if run_id is empty. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :activity_id, 2, type: :string, json_name: "activityId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :identity, 4, type: :string
  field :request_id, 5, type: :string, json_name: "requestId"
  field :reason, 6, type: :string
end
