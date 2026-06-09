defmodule Temporal.CoreSdk.Data.WorkflowActivationJobVariant do
  defstruct initialize_workflow: nil,
            fire_timer: nil,
            update_random_seed: nil,
            query_workflow: nil,
            cancel_workflow: nil,
            signal_workflow: nil,
            resolve_activity: nil,
            notify_has_patch: nil,
            resolve_child_workflow_execution_start: nil,
            resolve_child_workflow_execution: nil,
            resolve_signal_external_workflow: nil,
            resolve_request_cancel_external_workflow: nil,
            do_update: nil,
            resolve_nexus_operation_start: nil,
            resolve_nexus_operation: nil,
            remove_from_cache: nil

  alias Temporal.CoreSdk.Data

  @type t ::
          {:initialize_workflow, Data.ActivationInitializeWorkflow.t()}
          | {:fire_timer, Data.ActivationFireTimer.t()}
          | {:update_random_seed, Data.ActivationUpdateRandomSeed.t()}
          | {:query_workflow, Data.ActivationQueryWorkflow.t()}
          | {:cancel_workflow, Data.ActivationCancelWorkflow.t()}
          | {:signal_workflow, Data.ActivationSignalWorkflow.t()}
          | {:resolve_activity, Data.ActivationResolveActivity.t()}
          | {:notify_has_patch, Data.ActivationNotifyHasPatch.t()}
          | {:resolve_child_workflow_execution_start,
             Data.ActivationResolveChildWorkflowExecutionStart.t()}
          | {:resolve_child_workflow_execution,
             Data.ActivationResolveChildWorkflowExecutionStart.t()}
          | {:resolve_signal_external_workflow, Data.ActivationResolveSignalExternalWorkflow.t()}
          | {:resolve_request_cancel_external_workflow,
             Data.ActivationResolveRequestCancelExternalWorkflow.t()}
          | {:do_update, Data.ActivationDoUpdate.t()}
          | {:resolve_nexus_operation_start, Data.ActivationResolveNexusOperationStart.t()}
          | {:resolve_nexus_operation, Data.ActivationResolveNexusOperation.t()}
          | {:remove_from_cache, Data.ActivationRemoveFromCache.t()}
end
