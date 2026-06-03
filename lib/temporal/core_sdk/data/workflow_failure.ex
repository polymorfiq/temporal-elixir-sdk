defmodule Temporal.CoreSdk.Data.WorkflowFailure do
  defstruct [
    :message,
    :source,
    :stack_trace,
    encoded_attributes: nil,
    cause: nil,
    failure_info: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          message: String.t(),
          source: String.t(),
          stack_trace: String.t(),
          encoded_attributes: Data.ActivationPayload.t() | nil,
          cause: t() | nil,
          failure_info: Data.WorkflowFailureInfo.t() | nil
        }
end
