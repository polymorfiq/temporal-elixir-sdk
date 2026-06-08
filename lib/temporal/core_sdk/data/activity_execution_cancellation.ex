defmodule Temporal.CoreSdk.Data.ActivityExecutionCancellation do
  defstruct failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }

  @type opts :: [{:failure, Data.WorkflowFailure.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    failure = struct!(__MODULE__, opts)

    failure =
      if opts[:failure] do
        update_in(failure, [Access.key(:failure)], &Data.WorkflowFailure.with_opts!/1)
      else
        failure
      end

    failure
  end
end
