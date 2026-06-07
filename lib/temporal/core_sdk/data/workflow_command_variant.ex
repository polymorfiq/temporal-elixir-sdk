defmodule Temporal.CoreSdk.Data.WorkflowCommandVariant do
  alias Temporal.CoreSdk.Data

  @type t ::
          {:start_timer, Data.WorkflowCommandStartTimer.t()}
          | {:schedule_activity, Data.WorkflowCommandScheduleActivity.t()}
          | {:respond_to_query, Data.WorkflowCommandRespondToQuery.t()}
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
          | {:modify_worflow_properties, Data.WorkflowCommandModifyWorkflowProperties.t()}
          | {:update_response, Data.WorkflowCommandUpdateResponse.t()}
          | {:schedule_nexus_operation, Data.WorkflowCommandScheduleNexusOperation.t()}
          | {:request_cancel_nexus_operation, Data.WorkflowCommandRequestCancelNexusOperation.t()}

  @type opts() :: [
          {:start_timer, Data.WorkflowCommandStartTimer.opts()}
          | {:schedule_activity, Data.WorkflowCommandScheduleActivity.opts()}
          | {:respond_to_query, Data.WorkflowCommandRespondToQuery.opts()}
          | {:request_cancel_activity, Data.WorkflowCommandRequestCancelActivity.opts()}
          | {:cancel_timer, Data.WorkflowCommandCancelTimer.opts()}
          | {:complete_workflow_execution, Data.WorkflowCommandCompleteWorkflowExecution.opts()}
          | {:fail_workflow_execution, Data.WorkflowCommandFailWorkflowExecution.opts()}
          | {:continue_as_new_workflow_execution,
             Data.WorkflowCommandContinueAsNewWorkflowExecution.opts()}
          | {:cancel_workflow_execution, Data.WorkflowCommandCancelWorkflowExecution.opts()}
          | {:set_patch_marker, Data.WorkflowCommandSetPatchMarker.opts()}
          | {:start_child_workflow_execution,
             Data.WorkflowCommandStartChildWorkflowExecution.opts()}
          | {:cancel_child_workflow_execution,
             Data.WorkflowCommandCancelChildWorkflowExecution.opts()}
          | {:request_cancel_external_workflow_execution,
             Data.WorkflowCommandRequestCancelExternalWorkflowExecution.opts()}
          | {:signal_external_workflow_execution,
             Data.WorkflowCommandSignalExternalWorkflowExecution.opts()}
          | {:cancel_signal_workflow, Data.WorkflowCommandCancelSignalWorkflow.opts()}
          | {:schedule_local_activity, Data.WorkflowCommandScheduleLocalActivity.opts()}
          | {:request_cancel_local_activity,
             Data.WorkflowCommandRequestCancelLocalActivity.opts()}
          | {:upsert_workflow_search_attributes,
             Data.WorkflowCommandUpsertWorkflowSearchAttributes.opts()}
          | {:modify_worflow_properties, Data.WorkflowCommandModifyWorkflowProperties.opts()}
          | {:update_response, Data.WorkflowCommandUpdateResponse.opts()}
          | {:schedule_nexus_operation, Data.WorkflowCommandScheduleNexusOperation.opts()}
          | {:request_cancel_nexus_operation,
             Data.WorkflowCommandRequestCancelNexusOperation.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  #  def with_opts!({:start_timer, opts}), do: Data.WorkflowCommandStartTimer.with_opts!(opts)
  #
  #  def with_opts!({:respond_to_query, opts}),
  #    do: Data.WorkflowCommandRespondToQuery.with_opts!(opts)
  #
  #  def with_opts!({:request_cancel_activity, opts}),
  #    do: Data.WorkflowCommandRequestCancelActivity.with_opts!(opts)
  #
  #  def with_opts!({:cancel_timer, opts}),
  #      do: Data.WorkflowCommandCancelTimer.with_opts!(opts)

  def with_opts!({:complete_workflow_execution, opts}),
    do:
      {:complete_workflow_execution,
       Data.WorkflowCommandCompleteWorkflowExecution.with_opts!(opts)}

  #  def with_opts!({:fail_workflow_execution, opts}),
  #      do: Data.WorkflowCommandFailWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:continue_as_new_workflow_execution, opts}),
  #      do: Data.WorkflowCommandContinueAsNewWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:cancel_workflow_execution, opts}),
  #      do: Data.WorkflowCommandCancelWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:set_patch_marker, opts}),
  #      do: Data.WorkflowCommandSetPatchMarker.with_opts!(opts)
  #
  #  def with_opts!({:start_child_workflow_execution, opts}),
  #      do: Data.WorkflowCommandStartChildWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:cancel_child_workflow_execution, opts}),
  #      do: Data.WorkflowCommandCancelChildWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:request_cancel_external_workflow_execution, opts}),
  #      do: Data.WorkflowCommandRequestCancelExternalWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:signal_external_workflow_execution, opts}),
  #      do: Data.WorkflowCommandSignalExternalWorkflowExecution.with_opts!(opts)
  #
  #  def with_opts!({:cancel_signal_workflow, opts}),
  #      do: Data.WorkflowCommandCancelSignalWorkflow.with_opts!(opts)
  #
  #  def with_opts!({:schedule_local_activity, opts}),
  #      do: Data.WorkflowCommandScheduleLocalActivity.with_opts!(opts)
  #
  #  def with_opts!({:request_cancel_local_activity, opts}),
  #      do: Data.WorkflowCommandRequestCancelLocalActivity.with_opts!(opts)
  #
  #  def with_opts!({:upsert_workflow_search_attributes, opts}),
  #      do: Data.WorkflowCommandUpsertWorkflowSearchAttributes.with_opts!(opts)
  #
  #  def with_opts!({:modify_worflow_properties, opts}),
  #      do: Data.WorkflowCommandModifyWorkflowProperties.with_opts!(opts)
  #
  #  def with_opts!({:update_response, opts}),
  #      do: Data.WorkflowCommandUpdateResponse.with_opts!(opts)
  #
  #  def with_opts!({:schedule_nexus_operation, opts}),
  #      do: Data.WorkflowCommandScheduleNexusOperation.with_opts!(opts)
  #
  #  def with_opts!({:request_cancel_nexus_operation, opts}),
  #      do: Data.WorkflowCommandRequestCancelNexusOperation.with_opts!(opts)
end
