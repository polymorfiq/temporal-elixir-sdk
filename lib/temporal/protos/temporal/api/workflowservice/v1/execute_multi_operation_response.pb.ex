defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationResponse do
  @moduledoc """
  IMPORTANT: For [StartWorkflow, UpdateWorkflow] combination ("Update-with-Start") when both
    1. the workflow update for the requested update ID has already completed, and
    2. the workflow for the requested workflow ID has already been closed,
  then you'll receive
    - an update response containing the update's outcome, and
    - a start response with a `status` field that reflects the workflow's current state.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`responses`** | `Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationResponse.Response` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :responses, 1,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflowservice.V1.ExecuteMultiOperationResponse.Response
end
