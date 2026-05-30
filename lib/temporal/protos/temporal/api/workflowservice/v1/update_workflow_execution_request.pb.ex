defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.UpdateWorkflowExecutionRequest do
  @moduledoc """
  (-- api-linter: core::0134=disabled
  aip.dev/not-precedent: Update RPCs don't follow Google API format. --)

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 3 | **`first_execution_run_id`** | `string` | If set, this call will error if the most recent (if no Run Id is set on |
  | 1 | **`namespace`** | `string` | The namespace name of the target Workflow. |
  | 5 | **`request`** | `Temporal.Protos.Temporal.Api.Update.V1.Request` | The request information that will be delivered all the way down to the |
  | 4 | **`wait_policy`** | `Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy` | Specifies client's intent to wait for Update results. |
  | 2 | **`workflow_execution`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | The target Workflow Id and (optionally) a specific Run Id thereof. |

  ### Additional Notes

    * `first_execution_run_id` (`string`): If set, this call will error if the most recent (if no Run Id is set on
      `workflow_execution`), or specified (if it is) Workflow Execution is not
      part of the same execution chain as this Id.
    * `request` (`Temporal.Protos.Temporal.Api.Update.V1.Request`): The request information that will be delivered all the way down to the
      Workflow Execution.
    * `wait_policy` (`Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy`): Specifies client's intent to wait for Update results.
      NOTE: This field works together with API call timeout which is limited by
      server timeout (maximum wait time). If server timeout is expired before
      user specified timeout, API call returns even if specified stage is not reached.
      Actual reached stage will be included in the response.
    * `workflow_execution` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): The target Workflow Id and (optionally) a specific Run Id thereof.
      (-- api-linter: core::0203::optional=disabled
          aip.dev/not-precedent: false positive triggered by the word "optional" --)

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field :namespace, 1, type: :string

  field :workflow_execution, 2,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution,
    json_name: "workflowExecution"

  field :first_execution_run_id, 3, type: :string, json_name: "firstExecutionRunId"

  field :wait_policy, 4,
    type: Temporal.Protos.Temporal.Api.Update.V1.WaitPolicy,
    json_name: "waitPolicy"

  field :request, 5, type: Temporal.Protos.Temporal.Api.Update.V1.Request
end
