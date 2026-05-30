defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartBatchOperationRequest do
  @moduledoc """
  Automatically generated module for StartBatchOperationRequest

  ## Fields

  | # | Name | Type | Notes |
  |---|------|------|-------|
  | 12 | **`cancellation_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationCancellation` |  |
  | 13 | **`deletion_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationDeletion` |  |
  | 5 | **`executions`** | `Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution` | Executions to apply the batch operation |
  | 3 | **`job_id`** | `string` | Job ID defines the unique ID for the batch job |
  | 6 | **`max_operations_per_second`** | `float` | Limit for the number of operations processed per second within this batch. |
  | 1 | **`namespace`** | `string` | Namespace that contains the batch operation |
  | 4 | **`reason`** | `string` | Reason to perform the batch operation |
  | 17 | **`reset_activities_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationResetActivities` |  |
  | 14 | **`reset_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationReset` |  |
  | 11 | **`signal_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationSignal` |  |
  | 10 | **`termination_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTermination` |  |
  | 16 | **`unpause_activities_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUnpauseActivities` |  |
  | 18 | **`update_activity_options_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateActivityOptions` |  |
  | 15 | **`update_workflow_options_operation`** | `Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateWorkflowExecutionOptions` |  |
  | 2 | **`visibility_query`** | `string` | Visibility query defines the the group of workflow to apply the batch operation |

  ### Additional Notes

    * `executions` (`Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution`): Executions to apply the batch operation
      This field and `visibility_query` are mutually exclusive
    * `max_operations_per_second` (`float`): Limit for the number of operations processed per second within this batch.
      Its purpose is to reduce the stress on the system caused by batch operations, which helps to prevent system
      overload and minimize potential delays in executing ongoing tasks for user workers.
      Note that when no explicit limit is provided, the server will operate according to its limit defined by the
      dynamic configuration key `worker.batcherRPS`. This also applies if the value in this field exceeds the
      server's configured limit.
    * `visibility_query` (`string`): Visibility query defines the the group of workflow to apply the batch operation
      This field and `executions` are mutually exclusive

  """
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof :operation, 0

  field :namespace, 1, type: :string
  field :visibility_query, 2, type: :string, json_name: "visibilityQuery"
  field :job_id, 3, type: :string, json_name: "jobId"
  field :reason, 4, type: :string

  field :executions, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution

  field :max_operations_per_second, 6, type: :float, json_name: "maxOperationsPerSecond"

  field :termination_operation, 10,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTermination,
    json_name: "terminationOperation",
    oneof: 0

  field :signal_operation, 11,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationSignal,
    json_name: "signalOperation",
    oneof: 0

  field :cancellation_operation, 12,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationCancellation,
    json_name: "cancellationOperation",
    oneof: 0

  field :deletion_operation, 13,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationDeletion,
    json_name: "deletionOperation",
    oneof: 0

  field :reset_operation, 14,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationReset,
    json_name: "resetOperation",
    oneof: 0

  field :update_workflow_options_operation, 15,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateWorkflowExecutionOptions,
    json_name: "updateWorkflowOptionsOperation",
    oneof: 0

  field :unpause_activities_operation, 16,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUnpauseActivities,
    json_name: "unpauseActivitiesOperation",
    oneof: 0

  field :reset_activities_operation, 17,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationResetActivities,
    json_name: "resetActivitiesOperation",
    oneof: 0

  field :update_activity_options_operation, 18,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateActivityOptions,
    json_name: "updateActivityOptionsOperation",
    oneof: 0
end
