defmodule Temporal.CoreSdk.Data.WorkflowCommandQuerySuccess do
  defstruct response: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          response: Data.ActivationPayload.t() | nil
        }
end
