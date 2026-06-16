defmodule TemporalEngineNif.Data.WorkflowCommandVariant do
  alias TemporalEngineNif.Data

  @type t ::
          {:start_timer, Data.WorkflowCommandStartTimer.t()}
          | {:schedule_activity, Data.WorkflowCommandScheduleActivity.t()}
          | {:respond_to_query, Data.WorkflowCommandQueryResult.t()}
          | {:request_cancel_activity, Data.WorkflowCommandRequestCancelActivity.t()}
          | {:cancel_timer, Data.WorkflowCommandCancelTimer.t()}
          | {:complete_workflow_execution, Data.WorkflowCommandCompleteWorkflowExecution.t()}
          | {:fail_workflow_execution, Data.WorkflowCommandFailWorkflowExecution.t()}
          | {:continue_as_new_workflow_execution,
             Data.WorkflowCommandContinueAsNewWorkflowExecution.t()}
          | {:cancel_workflow_execution, Data.WorkflowCommandCancelWorkflowExecution.t()}
          | {:set_patch_marker, Data.WorkflowCommandSetPatchMarker.t()}
          | {:start_child_workflow_execution, Data.WorkflowCommandStartChildWorkflowExecution.t()}
          | {:cancel_child_workflow_execution,
             Data.WorkflowCommandCancelChildWorkflowExecution.t()}
          | {:request_cancel_external_workflow_execution,
             Data.WorkflowCommandRequestCancelExternalWorkflowExecution.t()}
          | {:signal_external_workflow_execution,
             Data.WorkflowCommandSignalExternalWorkflowExecution.t()}
          | {:cancel_signal_workflow, Data.WorkflowCommandCancelSignalWorkflow.t()}
          | {:schedule_local_activity, Data.WorkflowCommandScheduleLocalActivity.t()}
          | {:request_cancel_local_activity, Data.WorkflowCommandRequestCancelLocalActivity.t()}
          | {:upsert_workflow_search_attributes,
             Data.WorkflowCommandUpsertWorkflowSearchAttributes.t()}
          | {:modify_workflow_properties, Data.WorkflowCommandModifyWorkflowProperties.t()}
          | {:update_response, Data.WorkflowCommandUpdateResponse.t()}
          | {:schedule_nexus_operation, Data.WorkflowCommandScheduleNexusOperation.t()}
          | {:request_cancel_nexus_operation, Data.WorkflowCommandRequestCancelNexusOperation.t()}
end
