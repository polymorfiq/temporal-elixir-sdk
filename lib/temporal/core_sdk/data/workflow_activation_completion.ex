defmodule Temporal.CoreSdk.Data.WorkflowActivationCompletion do
  defstruct [:run_id, :status]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          run_id: String.t(),
          status:
            {:successful, Data.WorkflowActivationCompletionSuccessStatus.t()}
            | {:failed, Data.WorkflowActivationCompletionFailureStatus.t()}
        }

  @type opts :: [
          {:run_id, String.t()}
          | {:status,
             Data.WorkflowActivationCompletionSuccessStatus.opts()
             | Data.WorkflowActivationCompletionFailureStatus.opts()}
        ]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    completion = struct!(__MODULE__, opts)

    completion =
      update_in(completion, [Access.key(:status)], fn
        {:successful, opts} ->
          {:successful, Data.WorkflowActivationCompletionSuccessStatus.with_opts!(opts)}

        {:failed, opts} ->
          {:failed, Data.WorkflowActivationCompletionFailureStatus.with_opts!(opts)}
      end)

    completion
  end
end
