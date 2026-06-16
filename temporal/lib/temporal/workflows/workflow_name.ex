defprotocol Temporal.Workflows.WorkflowName do
  @spec execution_arities(t(), atom()) :: {:ok, [pos_integer()]} | {:error, term()}
  def execution_arities(_name, _execute_fn)

  @spec server_recognized_name(t(), atom()) :: String.t()
  def server_recognized_name(_name, _execute_fn)
end

defimpl Temporal.Workflows.WorkflowName, for: BitString do
  def execution_arities(_name, _execute_fn), do: {:error, :unknown}
  def server_recognized_name(name, _execute_fn), do: name
end

defimpl Temporal.Workflows.WorkflowName, for: Atom do
  def execution_arities(name, execute_fn) do
    if is_module?(name) do
      {:ok, name.__info__(:functions) |> Keyword.get_values(execute_fn) |> Enum.uniq()}
    else
      {:error, :unknown}
    end
  end

  def server_recognized_name(name, execute_fn) do
    cond do
      execute_fn == :execute && is_module?(name) &&
          Kernel.function_exported?(name, :workflow_type, 0) ->
        name.workflow_type()

      true ->
        short_name = Module.split(name) |> List.last() |> to_string()

        if execute_fn == :execute do
          short_name
        else
          "#{short_name}.#{execute_fn}"
        end
    end
  end

  defp is_module?(name) when is_atom(name) do
    _ = Code.ensure_loaded(name)

    Kernel.function_exported?(name, :__info__, 1)
  end

  defp is_module?(_), do: false
end
