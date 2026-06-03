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

  @type t :: %__MODULE__{
          initialize_workflow: Data.ActivationInitializeWorkflow.t() | nil,
          fire_timer: Data.ActivationFireTimer.t() | nil,
          update_random_seed: Data.ActivationUpdateRandomSeed.t() | nil,
          query_workflow: Data.ActivationQueryWorkflow.t() | nil,
          cancel_workflow: Data.ActivationCancelWorkflow.t() | nil,
          signal_workflow: Data.ActivationSignalWorkflow.t() | nil,
          resolve_activity: Data.ActivationResolveActivity.t() | nil,
          notify_has_patch: Data.ActivationNotifyHasPatch.t() | nil,
          resolve_child_workflow_execution_start:
            Data.ActivationResolveChildWorkflowExecutionStart.t() | nil,
          resolve_child_workflow_execution:
            Data.ActivationResolveChildWorkflowExecution.t() | nil,
          resolve_signal_external_workflow:
            Data.ActivationResolveSignalExternalWorkflow.t() | nil,
          resolve_request_cancel_external_workflow:
            Data.ActivationResolveRequestCancelExternalWorkflow.t() | nil,
          do_update: Data.ActivationDoUpdate.t() | nil,
          resolve_nexus_operation_start: Data.ActivationResolveNexusOperationStart.t() | nil,
          resolve_nexus_operation: Data.ActivationResolveNexusOperation.t() | nil,
          remove_from_cache: Data.ActivationRemoveFromCache.t() | nil
        }
end
