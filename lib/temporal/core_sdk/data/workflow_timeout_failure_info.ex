defmodule Temporal.CoreSdk.Data.WorkflowTimeoutFailureInfo do
  defstruct [
    :timeout_type,
    last_heartbeat_details: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          timeout_type: integer(),
          last_heartbeat_details: Data.ActivationPayloads.t() | nil
        }
end
