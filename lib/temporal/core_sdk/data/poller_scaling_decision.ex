defmodule Temporal.CoreSdk.Data.PollerScalingDecision do
  defstruct [:poll_request_delta_suggestion]

  @type t :: %__MODULE__{
          poll_request_delta_suggestion: integer()
        }
end
