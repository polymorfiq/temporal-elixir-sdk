defmodule Temporal.CoreSdk.Data.WorkflowResetFailureInfo do
  defstruct last_heartbeat_details: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          last_heartbeat_details: Data.ActivationPayloads.t() | nil
        }
end
