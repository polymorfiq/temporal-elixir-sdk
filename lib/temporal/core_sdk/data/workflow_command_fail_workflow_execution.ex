defmodule Temporal.CoreSdk.Data.WorkflowCommandFailWorkflowExecution do
  defstruct failure: nil

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          failure: Data.WorkflowFailure.t() | nil
        }

  @type opts :: [{:failure, Data.WorkflowFailure.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    fail = struct!(__MODULE__, opts)
    fail = update_in(fail, [Access.key(:failure)], &Data.WorkflowFailure.with_opts!/1)
    fail
  end
end
