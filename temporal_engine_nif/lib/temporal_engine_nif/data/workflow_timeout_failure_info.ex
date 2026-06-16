defmodule TemporalEngineNif.Data.WorkflowTimeoutFailureInfo do
  defstruct timeout_type: :unspecified,
            last_heartbeat_details: nil

  alias TemporalEngineNif.Data

  @type timeout_type ::
          :unspecified | :start_to_close | :schedule_to_start | :schedule_to_close | :heartbeat
  @type t :: %__MODULE__{
          timeout_type: timeout_type(),
          last_heartbeat_details: Data.Payload.t() | nil
        }
end
