defmodule Temporal.Protos.Temporal.Api.Workflowservice.V1.DescribeWorkflowExecutionResponse do
  @moduledoc false
  use Protobuf, protoc_gen_elixir_version: "0.16.0", syntax: :proto3

  field(:execution_config, 1,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionConfig,
    json_name: "executionConfig"
  )

  field(:workflow_execution_info, 2,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionInfo,
    json_name: "workflowExecutionInfo"
  )

  field(:pending_activities, 3,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingActivityInfo,
    json_name: "pendingActivities"
  )

  field(:pending_children, 4,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingChildExecutionInfo,
    json_name: "pendingChildren"
  )

  field(:pending_workflow_task, 5,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingWorkflowTaskInfo,
    json_name: "pendingWorkflowTask"
  )

  field(:callbacks, 6,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.CallbackInfo
  )

  field(:pending_nexus_operations, 7,
    repeated: true,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.PendingNexusOperationInfo,
    json_name: "pendingNexusOperations"
  )

  field(:workflow_extended_info, 8,
    type: Temporal.Protos.Temporal.Api.Workflow.V1.WorkflowExecutionExtendedInfo,
    json_name: "workflowExtendedInfo"
  )
end
