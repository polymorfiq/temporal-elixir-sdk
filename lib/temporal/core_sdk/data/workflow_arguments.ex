defmodule Temporal.CoreSdk.Data.WorkflowArguments do
  defstruct [:args]

  alias Temporal.CoreSdk.Data.WorkflowInput

  @type t :: %__MODULE__{args: [WorkflowInput.t()]}
  @type opts :: [{:args, [WorkflowInput.opts()]}] | [WorkflowInput.opts()]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    if Keyword.keyword?(opts) do
      args = struct!(__MODULE__, opts)

      args =
        update_in(args, [Access.key(:args)], fn inputs ->
          Enum.map(inputs, &WorkflowInput.with_opts!/1)
        end)

      args
    else
      %__MODULE__{args: Enum.map(opts, &WorkflowInput.with_opts!/1)}
    end
  end
end
