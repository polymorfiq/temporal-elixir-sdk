defmodule TemporalEngine.Data.Activation do
  use TemporalEngine.Data.TypeSpec

  alias TemporalEngine.Data.Activation
  alias TemporalEngine.Data.Timestamp
  alias TemporalEngine.Data.Jobs

  deftype :activation do
    @structdoc "An instruction to the lang sdk to run some workflow code, whether for the first time or from a cached state."

    @doc """
    The id of the currently active run of the workflow. Also used as a cache key.

    There may only ever be one active workflow task (and hence activation) of a run at one time.
    """
    @type run_id :: required :: String.t()

    @doc "The current time as understood by the workflow, which is set by workflow task started events"
    @type timestamp :: Timestamp.timestamp()

    @doc "Whether or not the activation is replaying past events"
    @type is_replaying :: required :: bool()

    @doc "Current history length as determined by the event id of the most recently processed event. This ensures that the number is always deterministic"
    @type history_length :: required :: pos_integer()

    @doc "The things to do upon activating the workflow"
    @type jobs :: required :: [Jobs.job()]

    @doc "Internal flags which are available for use by lang. If is_replaying is false, all internal flags may be used. This is not a delta - all previously used flags always appear since this representation is cheap."
    @type available_internal_flags :: required :: [pos_integer()]

    @doc "The history size in bytes as of the last WFT started event"
    @type history_size_bytes :: pos_integer()

    @doc "Set true if the most recent WFT started event had this suggestion"
    @type continue_as_new_suggested :: bool()

    @doc """
    Set to the deployment version of the worker that processed this task, which may be empty.

    During replay this version may not equal the version of the replaying worker.

    If not replaying and this worker has a defined Deployment Version, it will equal that.

    It will also be empty for evict-only activations. The deployment name may be empty, but not the build id, if this worker was using the deprecated Build ID-only feature(s).
    """
    @type deployment_version_for_current_task :: Activation.worker_deployment_version()

    @doc "The last seen SDK version from the most recent WFT completed event"
    @type last_sdk_version :: String.t()

    @doc "Experimental. Optionally decide the versioning behavior that the first task of the new run should use. For example, choose to AutoUpgrade on continue-as-new instead of inheriting the pinned version of the previous run."
    @type suggest_continue_as_new_reasons :: [Activation.continue_as_new_reason()]

    @doc "Experimental. True if Workflow’s Target Worker Deployment Version is different from its Pinned Version and the workflow is Pinned."
    @type target_worker_deployment_version_changed :: bool()
  end

  deftype :worker_deployment_version do
    @type build_id :: required :: String.t()
    @type deployment_name :: required :: String.t()
  end

  @type continue_as_new_reason ::
          :unspecified | :history_size_too_large | :too_many_history_events | :too_many_updates
end
