defmodule Temporal.CoreSdk.Data.ActivationRemoveFromCache do
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
          reason: integer()
        }
end
