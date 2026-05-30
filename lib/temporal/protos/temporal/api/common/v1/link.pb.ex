defmodule Temporal.Protos.Temporal.Api.Common.V1.Link do
  @moduledoc """
  Link can be associated with history events. It might contain information about an external entity
  related to the history event. For example, workflow A makes a Nexus call that starts workflow B:
  in this case, a history event in workflow A could contain a Link to the workflow started event in
  workflow B, and vice-versa.

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`activity`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.Activity` |  |
  | 2 | **`batch_job`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.BatchJob` |  |
  | 4 | **`nexus_operation`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.NexusOperation` |  |
  | 5 | **`workflow`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.Workflow` |  |
  | 1 | **`workflow_event`** | `Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent` |  |

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :variant, 0

  field :workflow_event, 1,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.WorkflowEvent,
    json_name: "workflowEvent",
    oneof: 0

  field :batch_job, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.BatchJob,
    json_name: "batchJob",
    oneof: 0

  field :activity, 3, type: Temporal.Protos.Temporal.Api.Common.V1.Link.Activity, oneof: 0

  field :nexus_operation, 4,
    type: Temporal.Protos.Temporal.Api.Common.V1.Link.NexusOperation,
    json_name: "nexusOperation",
    oneof: 0

  field :workflow, 5, type: Temporal.Protos.Temporal.Api.Common.V1.Link.Workflow, oneof: 0
end
