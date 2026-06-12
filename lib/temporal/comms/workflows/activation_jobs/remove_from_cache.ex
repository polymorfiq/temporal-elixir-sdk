defmodule Temporal.Comms.Workflows.ActivationJobs.RemoveFromCache do
  defstruct [:message, :reason]

  @type cache_eviction_reason ::
          :unspecified
          | :cache_full
          | :cache_miss
          | :non_determinism
          | :lang_fail
          | :lang_requested
          | :task_not_found
          | :unhandled_command
          | :fatal
          | :pagination_or_history_fetch
          | :workflow_execution_ending

  @type t :: %__MODULE__{
          message: String.t(),
          reason: cache_eviction_reason()
        }

  @type remove_from_cache :: {:remove_from_cache, cache_eviction_reason(), message :: String.t()}

  def send_to_sdk(%__MODULE__{} = activation) do
    {:remove_from_cache, activation.reason, activation.message}
  end
end
