defmodule Temporal.CoreSdk.Data.WorkflowCommandUpdateResponseStatus do
  defstruct accepted: nil, rejected: nil, completed: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          accepted: bool() | nil,
          rejected: Data.WorkflowFailure.t() | nil,
          completed: Data.ActivationPayload.t() | nil
        }
end
