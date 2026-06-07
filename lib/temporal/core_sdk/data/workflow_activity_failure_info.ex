defmodule Temporal.CoreSdk.Data.WorkflowActivityFailureInfo do
  defstruct [
    :scheduled_event_id,
    :started_event_id,
    :identity,
    :activity_id,
    retry_state: :unspecified,
    activity_type: nil
  ]

  alias Temporal.CoreSdk.Data

  @type retry_state ::
          :unspecified
          | :in_progress
          | :non_retryable_failure
          | :timeout
          | :maximum_attempts_reached
          | :retry_policy_not_set
          | :internal_server_error
          | :cancel_requested

  @type t :: %__MODULE__{
          scheduled_event_id: integer(),
          started_event_id: integer(),
          identity: String.t(),
          activity_type: Data.WorkflowActivityType.t() | nil,
          activity_id: String.t(),
          retry_state: integer()
        }
end
