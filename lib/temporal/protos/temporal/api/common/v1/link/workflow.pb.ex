defmodule Temporal.Protos.Temporal.Api.Common.V1.Link.Workflow do
  @moduledoc """
  Link can be associated with history events. It might contain information about an external entity
  related to the history event. For example, workflow A makes a Nexus call that starts workflow B:
  in this case, a history event in workflow A could contain a Link to the workflow started event in
  workflow B, and vice-versa.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`namespace`** | `string` |  |
  | 4 | **`reason`** | `string` |  |
  | 3 | **`run_id`** | `string` |  |
  | 2 | **`workflow_id`** | `string` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string
  field :workflow_id, 2, type: :string, json_name: "workflowId"
  field :run_id, 3, type: :string, json_name: "runId"
  field :reason, 4, type: :string
end
