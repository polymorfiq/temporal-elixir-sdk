defmodule Temporal.Protos.Temporal.Api.Errordetails.V1.WorkflowExecutionAlreadyStartedFailure do
  @moduledoc """
  Automatically generated module for WorkflowExecutionAlreadyStartedFailure

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 2 | **`run_id`** | `string` |  |
  | 1 | **`start_request_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :start_request_id, 1, type: :string, json_name: "startRequestId"
  field :run_id, 2, type: :string, json_name: "runId"
end
