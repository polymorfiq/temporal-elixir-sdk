defmodule Temporal.Comms.Workflows.Activation do
  alias Temporal.Comms.Shared
  alias Temporal.Comms.Workflows.ActivationJobs.InitializeWorkflow

  defstruct [
    :run_id,
    :is_replaying,
    :history_length,
    :jobs,
    :available_internal_flags,
    :history_size_bytes,
    :continue_as_new_suggested,
    :last_sdk_version,
    :suggest_continue_as_new_reasons,
    :target_worker_deployment_version_changed,
    timestamp: nil,
    deployment_version_for_current_task: nil
  ]

  @type activation ::
          {:activation, run_id(), activation_opts()} | {:activation, run_id(), [activation_job()]}

  @type activation_opts :: [
          {:timestamp, Shared.timestamp()}
          | {:is_replaying, bool()}
          | {:history_length, pos_integer()}
          | {:jobs, [activation_job()]}
          | {:available_internal_flags, [pos_integer()]}
          | {:history_size_bytes, pos_integer()}
          | {:continue_as_new_suggested, bool()}
          | {:deployment_version_for_current_task, deployment_version()}
          | {:last_sdk_version, String.t()}
          | {:suggest_continue_as_new_reasons, [integer()]}
          | {:target_worker_deployment_version_changed, bool()}
        ]

  @type run_id :: String.t()
  @type deployment_version :: {build_id :: String.t(), deployment_name :: String.t()}

  @type activation_job ::
          {:initialize_workflow, InitializeWorkflow.initialize_workflow()}
  #          | {:fire_timer, Data.ActivationFireTimer.t()}
  #          | {:update_random_seed, Data.ActivationUpdateRandomSeed.t()}
  #          | {:query_workflow, Data.ActivationQueryWorkflow.t()}
  #          | {:cancel_workflow, Data.ActivationCancelWorkflow.t()}
  #          | {:signal_workflow, Data.ActivationSignalWorkflow.t()}
  #          | {:resolve_activity, Data.ActivationResolveActivity.t()}
  #          | {:notify_has_patch, Data.ActivationNotifyHasPatch.t()}
  #          | {:resolve_child_workflow_execution_start,
  #             Data.ActivationResolveChildWorkflowExecutionStart.t()}
  #          | {:resolve_child_workflow_execution,
  #             Data.ActivationResolveChildWorkflowExecutionStart.t()}
  #          | {:resolve_signal_external_workflow, Data.ActivationResolveSignalExternalWorkflow.t()}
  #          | {:resolve_request_cancel_external_workflow,
  #             Data.ActivationResolveRequestCancelExternalWorkflow.t()}
  #          | {:do_update, Data.ActivationDoUpdate.t()}
  #          | {:resolve_nexus_operation_start, Data.ActivationResolveNexusOperationStart.t()}
  #          | {:resolve_nexus_operation, Data.ActivationResolveNexusOperation.t()}
  #          | {:remove_from_cache, Data.ActivationRemoveFromCache.t()}

  def send_to_sdk(%__MODULE__{} = msg) do
    opts = msg |> Map.from_struct() |> Keyword.new() |> Keyword.drop([:run_id])

    opts =
      update_in(
        opts,
        [:jobs],
        &Enum.map(&1 || [], fn
          %{variant: {_variant_name, %variant_mod{} = variant}} ->
            variant_mod.send_to_sdk(variant)
        end)
      )

    {:activation, msg.run_id, opts}
  end
end
