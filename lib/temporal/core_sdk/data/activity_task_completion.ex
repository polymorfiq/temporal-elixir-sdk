defmodule Temporal.CoreSdk.Data.ActivityTaskCompletion do
  defstruct [
    :task_token,
    result: nil
  ]

  alias Temporal.CoreSdk.Data

  @type t :: %__MODULE__{
          task_token: [byte()],
          result: Data.ActivityExecutionResult.t() | nil
        }

  @type opts :: [{:task_token, [byte()]} | {:result, Data.ActivityExecutionResult.opts()}]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    completion = struct!(__MODULE__, opts)

    completion =
      if opts[:result] do
        update_in(completion, [Access.key(:result)], &Data.ActivityExecutionResult.with_opts!/1)
      else
        completion
      end

    completion
  end
end
