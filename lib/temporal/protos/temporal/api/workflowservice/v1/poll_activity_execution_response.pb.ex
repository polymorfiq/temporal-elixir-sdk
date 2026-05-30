defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.PollActivityExecutionResponse do
  @moduledoc """
  Automatically generated module for PollActivityExecutionResponse

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`outcome`** | `Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome` |  |
  | 1 | **`run_id`** | `string` | The run ID of the activity, useful when run_id was not specified in the request. |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :run_id, 1, type: :string, json_name: "runId"
  field :outcome, 2, type: Temporal.Protos.Temporal.Api.Activity.V1.ActivityExecutionOutcome
end
