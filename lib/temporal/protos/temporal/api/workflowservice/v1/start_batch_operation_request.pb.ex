defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.StartBatchOperationRequest do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  oneof(:operation, 0)

  field(:namespace, 1, type: :string)
  field(:visibility_query, 2, type: :string, json_name: "visibilityQuery")
  field(:job_id, 3, type: :string, json_name: "jobId")
  field(:reason, 4, type: :string)

  field(:executions, 5,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Common.V1.WorkflowExecution
  )

  field(:max_operations_per_second, 6, type: :float, json_name: "maxOperationsPerSecond")

  field(:termination_operation, 10,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationTermination,
    json_name: "terminationOperation",
    oneof: 0
  )

  field(:signal_operation, 11,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationSignal,
    json_name: "signalOperation",
    oneof: 0
  )

  field(:cancellation_operation, 12,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationCancellation,
    json_name: "cancellationOperation",
    oneof: 0
  )

  field(:deletion_operation, 13,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationDeletion,
    json_name: "deletionOperation",
    oneof: 0
  )

  field(:reset_operation, 14,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationReset,
    json_name: "resetOperation",
    oneof: 0
  )

  field(:update_workflow_options_operation, 15,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateWorkflowExecutionOptions,
    json_name: "updateWorkflowOptionsOperation",
    oneof: 0
  )

  field(:unpause_activities_operation, 16,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUnpauseActivities,
    json_name: "unpauseActivitiesOperation",
    oneof: 0
  )

  field(:reset_activities_operation, 17,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationResetActivities,
    json_name: "resetActivitiesOperation",
    oneof: 0
  )

  field(:update_activity_options_operation, 18,
    type: Temporal.Protos.Temporal.Api.Batch.V1.BatchOperationUpdateActivityOptions,
    json_name: "updateActivityOptionsOperation",
    oneof: 0
  )
end
