defmodule Temporal.Protos.Temporal.Api.Schedule.V1.ScheduleAction do
  @moduledoc """
  Automatically generated module for ScheduleAction

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 1 | **`start_workflow`** | `Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo` | All fields of NewWorkflowExecutionInfo are valid except for: |

  ### Additional Notes

    * `start_workflow` (`Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo`): All fields of NewWorkflowExecutionInfo are valid except for:
      - workflow_id_reuse_policy
      - cron_schedule
      The workflow id of the started workflow may not match this exactly,
      it may have a timestamp appended for uniqueness.

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :action, 0

  field :start_workflow, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.NewWorkflowExecutionInfo,
    json_name: "startWorkflow",
    oneof: 0
end
