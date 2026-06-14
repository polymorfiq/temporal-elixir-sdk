defmodule TemporalEngineNif.Data.WorkflowArguments do
  defstruct [:args]

  alias TemporalEngineNif.Data.WorkflowInput

  @type t :: %__MODULE__{args: [WorkflowInput.t()]}

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
