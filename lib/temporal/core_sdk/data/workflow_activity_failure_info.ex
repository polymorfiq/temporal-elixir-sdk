defmodule Temporal.CoreSdk.Data.WorkflowActivityFailureInfo do
  defstruct [
    :scheduled_event_id,
    :started_event_id,
    :identity,
    :activity_id,
    :retry_state,
    activity_type: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          scheduled_event_id: integer(),
          started_event_id: integer(),
          identity: String.t(),
          activity_type: Data.WorkflowActivityType.t() | nil,
          activity_id: String.t(),
          retry_state: integer()
        }
end
