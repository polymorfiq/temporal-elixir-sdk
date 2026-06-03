defmodule Temporal.CoreSdk.Data.WorkflowCommandVariant do
  defstruct start_timer: nil,
            schedule_activity: nil,
            respond_to_query: nil,
            request_cancel_activity: nil,
            cancel_timer: nil,
            complete_workflow_execution: nil,
            fail_workflow_execution: nil,
            continue_as_new_workflow_execution: nil,
            cancel_workflow_execution: nil,
            set_patch_marker: nil,
            start_child_workflow_execution: nil,
            cancel_child_workflow_execution: nil,
            request_cancel_external_workflow_execution: nil,
            signal_external_workflow_execution: nil,
            cancel_signal_workflow: nil,
            schedule_local_activity: nil,
            request_cancel_local_activity: nil,
            upsert_workflow_search_attributes: nil,
            modify_worflow_properties: nil,
            update_response: nil,
            schedule_nexus_operation: nil,
            request_cancel_nexus_operation: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          start_timer: Data.WorkflowCommandStartTimer.t() | nil,
          schedule_activity: Data.WorkflowCommandScheduleActivity.t() | nil,
          respond_to_query: Data.WorkflowCommandRespondToQuery.t() | nil,
          request_cancel_activity: Data.WorkflowCommandRequestCancelActivity.t() | nil,
          cancel_timer: Data.WorkflowCommandCancelTimer.t() | nil,
          complete_workflow_execution: Data.WorkflowCommandCompleteWorkflowExecution.t() | nil,
          fail_workflow_execution: Data.WorkflowCommandFailWorkflowExecution.t() | nil,
          continue_as_new_workflow_execution:
            Data.WorkflowCommandContinueAsNewWorkflowExecution.t() | nil,
          cancel_workflow_execution: Data.WorkflowCommandCancelWorkflowExecution.t() | nil,
          set_patch_marker: Data.WorkflowCommandSetPatchMarker.t() | nil,
          start_child_workflow_execution:
            Data.WorkflowCommandStartChildWorkflowExecution.t() | nil,
          cancel_child_workflow_execution:
            Data.WorkflowCommandCancelChildWorkflowExecution.t() | nil,
          request_cancel_external_workflow_execution:
            Data.WorkflowCommandRequestCancelExternalWorkflowExecution.t() | nil,
          signal_external_workflow_execution:
            Data.WorkflowCommandSignalExternalWorkflowExecution.t() | nil,
          cancel_signal_workflow: Data.WorkflowCommandCancelSignalWorkflow.t() | nil,
          schedule_local_activity: Data.WorkflowCommandScheduleLocalActivity.t() | nil,
          request_cancel_local_activity: Data.WorkflowCommandRequestCancelLocalActivity.t() | nil,
          upsert_workflow_search_attributes:
            Data.WorkflowCommandUpsertWorkflowSearchAttributes.t() | nil,
          modify_worflow_properties: Data.WorkflowCommandModifyWorkflowProperties.t() | nil,
          update_response: Data.WorkflowCommandUpdateResponse.t() | nil,
          schedule_nexus_operation: Data.WorkflowCommandScheduleNexusOperation.t() | nil,
          request_cancel_nexus_operation:
            Data.WorkflowCommandRequestCancelNexusOperation.t() | nil
        }
end
