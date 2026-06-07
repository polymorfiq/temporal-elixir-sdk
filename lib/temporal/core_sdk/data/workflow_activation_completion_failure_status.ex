defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletionFailureStatus do
  defstruct [:force_cause, failure: nil]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil,
          force_cause: integer()
        }

  @type opts :: [{:failure, Data.WorkflowFailure.opts()}, {:force_cause, integer()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    status = struct!(__MODULE__, opts)

    status =
      if opts[:failure] do
        update_in(status, [Access.key(:failure)], &Data.WorkflowFailure.with_opts!/1)
      else
        status
      end

    status
  end
end
