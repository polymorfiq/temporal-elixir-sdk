defprotocol Temporal.Workflows.WorkflowName do
  @spec execution_arities(t()) :: {:ok, [pos_integer()]} | {:error, term()}
  def execution_arities(_name)

  @spec server_recognized_name(t()) :: String.t()
  def server_recognized_name(_name)
end

defimpl Temporal.Workflows.WorkflowName, for: BitString do
  def execution_arities(_name), do: {:error, :unknown}
  def server_recognized_name(name), do: name
end

defimpl Temporal.Workflows.WorkflowName, for: Atom do
  def execution_arities(name) do
    if is_module?(name) do
      {:ok, name.__info__(:functions) |> Keyword.get_values(:execute) |> Enum.uniq()}
    else
      {:error, :unknown}
    end
  end

  def server_recognized_name(name) do
    cond do
      is_binary(name) ->
        name

      is_module?(name) && Kernel.function_exported?(name, :workflow_type, 0) ->
        name.workflow_type()

      true ->
        Module.split(name) |> List.last() |> to_string()
    end
  end

  defp is_module?(name) when is_atom(name) do
    _ = Code.ensure_loaded(name)

    Kernel.function_exported?(name, :__info__, 1)
  end

  defp is_module?(_), do: false
end
