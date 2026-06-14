defmodule TemporalEngineNif.Data.WorkflowArguments do
  defstruct [:args]

  alias TemporalEngineNif.Data.WorkflowInput

  @type t :: %__MODULE__{args: [WorkflowInput.t()]}
  @type opts :: [{:args, [WorkflowInput.opts()]}] | [WorkflowInput.opts()]

  @spec with_opts!(opts()) :: t()
  def with_opts!(opts) do
    cond do
      Keyword.keyword?(opts) ->
        args = struct!(__MODULE__, opts)

        args =
          update_in(args, [Access.key(:args)], fn inputs ->
            Enum.map(inputs, &WorkflowInput.with_opts!/1)
          end)

        args

      is_list(opts) ->
        %__MODULE__{args: Enum.map(opts, &WorkflowInput.with_opts!/1)}

      true ->
        raise "Unknown argument type received: #{inspect(opts)}"
    end
  end

  @spec to_workflow_result(t()) :: {:ok, term()} | {:error, term()}
  def to_workflow_result(args) do
    case args do
      %__MODULE__{args: [output]} ->
        {:ok, WorkflowInput.to_val!(output)}

      %__MODULE__{args: outputs} ->
        {:ok, Enum.map(outputs, &WorkflowInput.to_val!/1) |> List.to_tuple()}

      result ->
        {:error, "Unknown result type: #{inspect(result)}"}
    end
  end
end
